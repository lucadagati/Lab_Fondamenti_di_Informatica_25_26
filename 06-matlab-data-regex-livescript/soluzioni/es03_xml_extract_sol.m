% Soluzione 3 - XML
baseDir = fileparts(fileparts(mfilename('fullpath')));
xmlPath = fullfile(baseDir, 'dati', 'pazienti_lab6.xml');
S = readstruct(xmlPath);

P = S.paziente;
n = numel(P);
id = strings(n,1);
nome = strings(n,1);
eta = zeros(n,1);
bpm = zeros(n,1);
spo2 = zeros(n,1);
sistolica = zeros(n,1);

for i = 1:n
    id(i) = string(P(i).Attribute.id);
    nome(i) = string(P(i).nome.Text);
    eta(i) = str2double(P(i).eta.Text);
    bpm(i) = str2double(P(i).bpm.Text);
    spo2(i) = str2double(P(i).spo2.Text);
    sistolica(i) = str2double(P(i).sistolica.Text);
end

T = table(id, nome, eta, bpm, spo2, sistolica);
disp(T)
