clear all
close all
clc

Outcomes{1,1} = readmatrix('C:\Users\piotr\Desktop\Engineerka\Dane pomiarowe\TestCurrINA_003_20.20.57_20.01.2025.txt');
Outcomes{1,2} = readmatrix('C:\Users\piotr\Desktop\Engineerka\Dane pomiarowe\TestRLT_000_11.54.02_22.01.2025.txt');
Outcomes{1,3} = readmatrix('C:\Users\piotr\Desktop\Engineerka\Dane pomiarowe\TestCurrHalls_002_19.41.13_20.01.2025.txt');

f_sample = 5000;
n = 500;

phase_colours = [[0.4660 0.6740 0.1880];[0.9290 0.6940 0.1250];[0 0.4470 0.7410]];
bar_text = [];
text_ = "Pomiar prądów fazowych z wykorzystaniem";
titles = [" czujnika prądu", "bazującego na efekcie Halla";
    " szeregowego rezystora", "w obwodzie fazowym silnika";
    " rezystora umieszczonego", "w obwodzie źródła dolnego tranzystora półmostka"];
for i = 1:size(Outcomes,2)
    t = Outcomes{1,i}(:,1) / 5; % s
    I_U = Outcomes{1,i}(:,2) / 1e6; % A
    I_W = Outcomes{1,i}(:,3) / 1e6; % A
    
    figure(i+1)
    plot(t,I_U, t, I_W);
    title(append(text_,titles(i,1)),titles(i,2),'fontweight','bold')
    legend("Prąd fazy U","Prąd fazy W")
    ylabel("Natężenie prądu fazowego [A]")
    xlabel("Czas [s]")
    ylim([-2.5 2.5])
    xlim([0 6/15])
    grid on
    grid minor
    
    THD_I_U = thd(I_U, f_sample, n);
    THD_perc(i,1) = 100*(10^(THD_I_U/20));
    THD_I_W = thd(I_W, f_sample, n);
    THD_perc(i,2) = 100*(10^(THD_I_W/20));
    bar_text = [bar_text, "Faza U","Faza W"];
end

X = categorical(["Dla metody nr 1","Dla metody nr 2","Dla metody nr 3"]);
X = reordercats(X,["Dla metody nr 1","Dla metody nr 2","Dla metody nr 3"]);
Y = round(THD_perc,2,'significant');
figure(1)
b = bar(X,Y);
%text(b.YEndPoints, string(Y), 'VerticalAlignment','bottom', 'HorizontalAlignment','center');
% b(1).FaceColor = phase_colours(1,:);
% b(2).FaceColor = phase_colours(2,:);
%title("Porównanie jakości pomiarów prądów fazowych")
Lgd = legend(["Faza U","Faza W"],'Location','northwest');
ylabel("THD [%]")
ylim([0, max(max(THD_perc)) + 0.5])
grid on
grid minor
