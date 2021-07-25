function [ns, epsilon, Sg, Upoznato, Sp, Z_trafoa, t_trafoa, Z_konc, Z_vodova, U_ref, ugao_ref] = Unos_podataka_projekat(naziv_datoteke,naziv_sheet)
%-------------- Funkcija za unos podataka iz Excel tabele ----------------- 
%--------------------------- Ulazni podaci --------------------------------
% naziv_datoteke - String koji sadrzi ime Excel datoteke sa podacima
% naziv_sheet - String koji sadrzi ime sheet-a u kojem se nalaze podaci
%-------------------------- Izlazni podaci --------------------------------
% ns - Broj sabirnica u mreži
% epsilon - Parametar konvergencije
% Sg - Matrica podataka o proizvodnji u mrezi (broj sabirnice i P)
% Upoznato - Poznati naponi na sabirnicama PU
% Sp - Matrica podataka o potrosnji u mrezi
% Z_trafoa - Matrica podataka o impedansama transformatora mreze
% t_trafoa - Uzimanje u obzir polozaja regulacione preklopke
% Z_konc - Matrica podataka o koncentrisanim parametrima mreze
% Z_vodova -  Matrica podataka o impedansama vodova razmatrane mreze
% U_ref - Vrijednost referentnog napona (p.u.)
% ugao_ref - Vrijednost referentnog ugla (rad)

% Upis broja sabirnica 
ns = xlsread(naziv_datoteke,naziv_sheet,'A1');

%Upis parametra konvergencije
epsilon = xlsread(naziv_datoteke, naziv_sheet, 'A45');

% Upis podatka o generatorima
ng = xlsread(naziv_datoteke,naziv_sheet,'A2');
brojac = 2+ng;
broj_slovo = num2str(brojac);

granice = strcat('A','3',':','C',broj_slovo);
granice_naponi1 = strcat('A', '3', ':', 'A', broj_slovo);
granice_naponi2 = strcat('D', '3', ':', 'D', broj_slovo);
granice_naponi3 = strcat('E', '3', ':', 'E', broj_slovo);
Sg = xlsread(naziv_datoteke,naziv_sheet,granice);
Upoznato = zeros(4,2);
Upoznato(:,1) = xlsread(naziv_datoteke, naziv_sheet, granice_naponi1);
Upoznato(:,2) = xlsread(naziv_datoteke, naziv_sheet, granice_naponi2);
Upoznato(:,3) = xlsread(naziv_datoteke, naziv_sheet, granice_naponi3);

% Upis podataka o potrosacima
pocetak = brojac + 1; %pocetak = 7
broj_slovo = num2str(pocetak);
vrijednost = strcat('A',broj_slovo);

np = xlsread(naziv_datoteke,naziv_sheet,vrijednost);

pocetak = pocetak + 1;
slovo_1 = num2str(pocetak);
kraj = pocetak + np - 1;
slovo_2 = num2str(kraj);
granice = strcat('A',slovo_1,':','C',slovo_2); 

Sp = xlsread(naziv_datoteke, naziv_sheet, granice);

% Upis podataka o transformatorima 
pocetak = kraj + 1; %19
broj_slovo = num2str(pocetak);
vrijednost = strcat('A',broj_slovo);

ntrafoa = xlsread(naziv_datoteke,naziv_sheet,vrijednost);

pocetak = pocetak + 1;
slovo_1 = num2str(pocetak);
kraj = pocetak + ntrafoa - 1; %24
slovo_2 = num2str(kraj);
granice = strcat('A',slovo_1,':','D',slovo_2);
granice_t = strcat('E', slovo_1, ':', 'E', slovo_2);
Z_trafoa = xlsread(naziv_datoteke, naziv_sheet, granice);
t_trafoa = xlsread(naziv_datoteke, naziv_sheet, granice_t);

%Upis podataka o koncentrisanim parametrima
pocetak = kraj + 1; %25
broj_slovo = num2str(pocetak);
vrijednost = strcat('A',broj_slovo);

nkonc = xlsread(naziv_datoteke,naziv_sheet,vrijednost);

pocetak = pocetak + 1; %26
slovo_1 = num2str(pocetak);
kraj = pocetak + nkonc - 1;
slovo_2 = num2str(kraj);
granice = strcat('A',slovo_1,':','D',slovo_2);

Z_konc = xlsread(naziv_datoteke,naziv_sheet,granice);

%Upis podataka o vodovima
pocetak = kraj + 1; %27
broj_slovo = num2str(pocetak);
vrijednost = strcat('A',broj_slovo);

nvodova = xlsread(naziv_datoteke,naziv_sheet,vrijednost);

pocetak = pocetak + 1;
slovo_1 = num2str(pocetak);
kraj = pocetak + nvodova - 1;
slovo_2 = num2str(kraj);
granice = strcat('A',slovo_1,':','D',slovo_2);

Z_vodova = xlsread(naziv_datoteke,naziv_sheet,granice);

% Upis podataka o referentnom naponu i uglu
pocetak = kraj + 1;
broj_slovo = num2str(pocetak);
vrijednost = strcat('A',broj_slovo);
U_ref = xlsread(naziv_datoteke,naziv_sheet,vrijednost);
vrijednost = strcat('B',broj_slovo);
ugao_ref = xlsread(naziv_datoteke,naziv_sheet,vrijednost);

