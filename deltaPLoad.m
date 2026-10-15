clc; clear;
%{
Sultan Favian Respati
NIM 13622009

Program Studi Teknik Dirgantara

Fakultas Teknik Mesin dan Dirgantara
Institut Teknologi Bandung
%}

%% Pemasukkan data ketinggian FDR
h = readmatrix('gag.txt');

%% Konversi ketinggian dari kaki ke meter
h = 0.3048.*h;

%% Perhitungan tekanan atmosfer untuk tiap nilai ketinggian
[~, ~, P] = atmosisa(h); %hanya variabel P yang akan digunakan
%P dalam satuan Pascal

%% Perhitungan perbedaan tekanan kabin dengan lingkungan

htresh = 8000*0.3048; %ketinggian batas 8000 ft dikonversi ke dalam meter
P8kft = atmosisa(htresh); %Tekanan atmosfer pada 8000 kaki (Pascal)
for i = 1:length(h)
    if h(i,1) <= 2438.4 %(m) ~ 8000 kaki
        deltaP(i,1) = 0;
    else
        deltaP(i,1) = P8kft - P(i,1);
    end
end

%% Perhitungan tegangan sirkumferensial pada struktur

%{
r = input('radius fuselage (m) : ');
t = input('ketebalan fuselage (m) : ');
%}

r = 5.94; %(m)
t = 1.5e-3; %(m)
sigma = deltaP*r/t; %tegangan sirkumferensial (Pascal)

%% Rainflow Counting
c = rainflow(sigma);

%Ekstraksi hasil rainflow counting
T = array2table(c,VariableNames=["Count" "Range" "Mean" "Start" "End"]);

%Penyajian dalam format .txt
writetable(T,'hasil rainflow.txt')