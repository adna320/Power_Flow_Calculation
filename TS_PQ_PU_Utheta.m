clc;
clear;
close all;

% Poziv funkcije za unos podataka
[ns, epsilon, Sg, Upoznato, Sp, Z_trafoa, t_trafoa, Z_konc, Z_vodova, U_ref, ugao_ref] = Unos_podataka_projekat('Projektni_zadatak','Podaci');

% Poziv funkcije za proracun tokova snaga
[iteracija, Usabirnica, I] = Proracun_TS_projektni(ns, epsilon, Sg, Upoznato, Sp, Z_trafoa, t_trafoa, Z_konc, Z_vodova, U_ref, ugao_ref);

% Ispis rezultata

disp('Z matricni metod - Gauss Seidel-ov postupak');

fprintf('\nBroj iteracija: %d\n', iteracija);
disp('Moduli napona sabirnica nakon iteracija: ');
disp(abs(Usabirnica(:,iteracija)));
disp('Uglovi napona sabirnica nakon iteracija: ');
disp(angle(Usabirnica(:,iteracija)));

    %Naponi na sabirnicama nakon proracuna
    Usabirnica = Usabirnica(:, iteracija);

    %Uglovi napona na sabirnicama nakon proracuna
    Uuglovi = angle(Usabirnica);

    
    %Snaga na sabirnicama
    Ssabirnica = Usabirnica(1:ns-1,:).*conj(I);

%Aktivna i reaktivna snaga na sabirnicama
disp('Aktivna snaga na sabirnicama nakon iteracija: ');
disp(real(Ssabirnica));
disp('Reaktivna snaga na sabirnicama nakon iteracija: ');
disp(imag(Ssabirnica));