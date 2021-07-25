function [iteracija, Usabirnica, I] = Proracun_TS_projektni(ns, epsilon, Sg, Upoznato, Sp, Z_trafoa, t_trafoa, Z_konc, Z_vodova, U_ref, ugao_ref)
%------------------ Funkcija za proracun tokova snaga ---------------------
% I - vektor kolona cvornih struja za iteraciju u kojoj rjesenje konvergira

%-------------------------- Izlazni podaci --------------------------------
% iteracija - Podatak o broju iteracija do postignute konvergencije
% Usabirnica - Matrica podataka o naponima tokom iteracija

% Pretvorba unesenih impedansi u provodnosti
a = length(Z_trafoa(:, 1));
b = length(Z_konc(:, 1));
c = length(Z_vodova(:, 1));
dimenzije = a + b + c;
Z_grana = zeros(dimenzije, 4);
for i = 1 : a
    for j = 1 : 4
        Z_grana(i, j) = Z_trafoa(i, j);
    end
end

for i = 1 : b
    for j = 1 : 4
        Z_grana(i + a, j) = Z_konc(i, j); 
    end
end
for i = 1 : c
    for j = 1 : 4
        Z_grana(i + a + b, j) = Z_vodova(i, j);
    end 
end

[n, m] = size(Z_grana);
for i=1:1:n
   Y_grana(i,1) = Z_grana(i,1);
   Y_grana(i,2) = Z_grana(i,2);
   realni = Z_grana(i,3);
   imaginarni = Z_grana(i,4);
   
   if realni == 0
       imaginarni = complex(0,imaginarni);
       impedansa = 1/imaginarni;
   else
       realni = complex(realni,0);
       imaginarni = complex(0,imaginarni);
       impedansa = 1/(realni+imaginarni);
   end
   
   Y_grana(i,3) = impedansa;
end

                % Popunjavanje matrice Y
            
[br_redova,br_kolona] = size(Y_grana);
Y = zeros(ns, ns);

% Popunjavanje provodnosti izmedju cvorova
for i=1:1:br_redova
    prvi = uint8(Y_grana(i,1));
    drugi = uint8(Y_grana(i,2));
    
    if (drugi ~= 0)
        Y(prvi,drugi) = -1 * Y_grana(i,3);
        Y(drugi,prvi) = Y(prvi,drugi);
    end
end

% Popunjavavanje dijagonalnih elemenata bez otocnih provodnosti
for i=1:1:ns
    Y(i,i) = -1*sum(Y(i,:));
end

% Popunjavanje dijagonalnih elemenata i otocnih provodnosti
for i=1:1:br_redova
    prvi = uint8(Y_grana(i,1));
    drugi = uint8(Y_grana(i,2));
    
    if (drugi == 0)
        Y(prvi,prvi) = Y(prvi,prvi) + Y_grana(i,3);
    end
end
%okej
% Formiranje vektora snaga proizvodnje i potrosnje u mrezi
% Popunjavanje proizvodnje
S = zeros(ns,1);
[n, ~] = size(Sg);
for i=1:1:n
    sabirnica = uint8(Sg(i,1));
    
    % Popunjavanje proizvodnje sa predznakom "+" u vektor snaga
    S(sabirnica,1) = complex(Sg(i,2), Sg(i,3));
end

% Popunjavanje potrosnje
[n, m] = size(Sp);
for i=1:1:n
    sabirnica = uint8(Sp(i,1));
    
    % Popunjavanje potrosnje sa predznakom "-" u vektor snaga
    S(sabirnica,1) = -complex(Sp(i,2), Sp(i,3));
end
                                % Proracun tokova snaga
iteracija = 1;
Usabirnica = zeros(ns,500); % Definisanje veoma velikih matrica
I = zeros(ns-1, 500);
                            % Z matricni metod - Gauss - Seidel
    %Poznat nam je utjecaj referentne sabirnice i napon na njoj
    Y0 = Y(:, 1);
    Y(1,:) = [];
    Y(:,1) = [];
    
    %Prije iteracijskog postupka izvrsimo inverziju matrice Y 
    Z = inv(Y); 
     %Usvajanje pocetnog vektora napona sabirnica
   for j = 1 : (ns-1)
        Usabirnica(j,iteracija) = complex(1,0); % 1 (p.u.)
   end
    % Posljednji element je referentni cvor
           napon = U_ref*exp(complex(0,ugao_ref));
           Usabirnica(ns,iteracija) = napon;
           
           
     % Unosimo module poznatih napona
     for i = 1 : length(Upoznato(:, 1))
         pozicija = uint8(Upoznato(i, 1));
         Usabirnica(pozicija, iteracija) = Upoznato(i, 2)*exp(complex(0, Upoznato(i,3)));
     end
     
     iteracija = iteracija+1;
    % Iterativni ciklus
  while true      
      %Cvorne struje
               for j = 1 : (ns-1)
               I(j, iteracija - 1) = (conj(S(j)) / conj(Usabirnica(j, iteracija - 1))) - (Y0(j)*napon);
               end
               
           U = Z * I(:,iteracija-1); % 13*1
           
           Usabirnica(1:ns-1,iteracija) = U;
           
    % Nakon proracuna napona sabirnica, prepisuje se referentna sabirnica i
    % poznati naponi na sabirnicama ali smo uzeli da su i uglovi napona na
    % PU sabirnicama poznati
            for i = 1 : length(Upoznato(:, 1))
                pozicija = uint8(Upoznato(i, 1));
                Usabirnica(pozicija, iteracija) = Usabirnica(pozicija, iteracija - 1);
            end
           Usabirnica(ns,iteracija) = Usabirnica(ns,iteracija-1);
       
       razlika = max(abs(abs(Usabirnica(:,iteracija))-abs(Usabirnica(:,iteracija-1))));
       iteracija = iteracija + 1;
       if  razlika < epsilon & iteracija > 2
           % Povratak jedne iteracije (radi povecanja u petlji, prekid)
           iteracija = iteracija - 1;
           break;
       end
    end
    % Skracivanje matrice (izuzimanje nulte iteracije - pocetni uslovi)
    Usabirnica = Usabirnica(1:ns,2:iteracija);
    iteracija = iteracija - 1;
    
    %Cvorne struje
    I = I(:, iteracija);
    
end