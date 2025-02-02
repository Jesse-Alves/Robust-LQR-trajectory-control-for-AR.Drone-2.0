% ======================================================
% === PROJETO DE CONTROLE CONSIDERANDO 4 SUBSISTEMAS ===
% ======================================================
clear all;
clc;
close all;
%% Tipo de Trajetoria
% circulo = 1 /// oito inclinado = 0
tipo = 1;
if tipo == 1
    chave_circular = 1;
    chave_oito = 0;
else
    chave_circular = 0;
    chave_oito = 1;
end
%% ==========> Parametros do AR.Drone 2.0 <============
Cx = 0.3;
Cy = 0.1;
g = 9.8;
Kz = 1.3;
Kpsi = 1;
Kfi = 1.5;
Ktheta = 1.5;
tz = 0.4;
tpsi = 0.3;
zmax = 1.0;
fimax = 0.26;
thetamax = 0.26;
psimax = 1.74;
wfi = 4.47;
wtheta = 4.47;
zetafi = 0.5;
zetatheta = 0.5;

%% PARAMETROS INCERTOS
%% Limite Inferior
tz1 = 0.4;
tpsi1 = 0.3;
Cx1 = 0.3;
Cy1 = 0.1;
%% Limite Superior
tz2 = 0.45;
tpsi2 = 0.4;
Cx2 = 0.9;
Cy2 = 0.5;


tz2 = 0.8;
tpsi2 = 0.4;
Cx2 = 1;
Cy2 = 3;


%% ===============================================
%  ========== SISTEMA LINEARIZADO ================
%  ===============================================
s = tf([1 0],[1]);

%% VARIAVEL Z
Az1 = [0 1;
      0 -1/tz1];
Az2 = [0 1;
      0 -1/tz2];
  
Bz1 = [0;
      (Kz*zmax)/(tz1)];
Bz2 = [0;
      (Kz*zmax)/(tz2)];
Cz = [1 0];
Dz = 0;

Az_a1 = [Az1 zeros([size(Az1,1),size(Bz1,2)]);-Cz zeros(size(Cz,1))];
Az_a2 = [Az2 zeros([size(Az2,1),size(Bz1,2)]);-Cz zeros(size(Cz,1))];
Az_a=[];
Az_a(:,:,1) = Az_a1;
Az_a(:,:,2) = Az_a2;

Bz_a1 = [Bz1;-Dz];
Bz_a2 = [Bz2;-Dz];
Bz_a=[];
Bz_a(:,:,1) = Bz_a1;
Bz_a(:,:,2) = Bz_a2;

Cz_a = [Cz zeros(size(Cz,1))];
%% VARIAVEL PSI
Apsi1 = [0 1;
        0 -1/tpsi1];
Apsi2 = [0 1;
        0 -1/tpsi2];    
    
Bpsi1 = [0;
       (Kpsi*psimax)/(tpsi1)];
Bpsi2 = [0;
       (Kpsi*psimax)/(tpsi2)];   
Cpsi = [1 0];
Dpsi = 0;
   
Apsi_a1 = [Apsi1 zeros([size(Apsi1,1),size(Bpsi1,2)]);-Cpsi zeros(size(Cpsi,1))];
Apsi_a2 = [Apsi2 zeros([size(Apsi2,1),size(Bpsi1,2)]);-Cpsi zeros(size(Cpsi,1))];
Apsi_a=[];
Apsi_a(:,:,1) = Apsi_a1;
Apsi_a(:,:,2) = Apsi_a2;

Bpsi_a1 = [Bpsi1;-Dpsi];
Bpsi_a2 = [Bpsi2;-Dpsi];
Bpsi_a=[];
Bpsi_a(:,:,1) = Bpsi_a1;
Bpsi_a(:,:,2) = Bpsi_a2;

Cpsi_a = [Cpsi zeros(size(Cpsi,1))];
%% VARIAVEL FI-Y 
Afi_y1 = [0 1 0 0;
       -wfi^2 -2*zetafi*wfi 0 0;
         0 0 0 1;
         -g 0 0 -Cy1];
Afi_y2 = [0 1 0 0;
       -wfi^2 -2*zetafi*wfi 0 0;
         0 0 0 1;
         -g 0 0 -Cy2];
     
Bfi_y = [0;Kfi*fimax*wfi^2;0;0];
    
Cfi_y = [0 0 1 0];
Dfi_y = [0];
    
Afi_y_a1 = [Afi_y1 zeros([size(Afi_y1,1),size(Bfi_y,2)]);
          -Cfi_y zeros(size(Cfi_y,1))];
Afi_y_a2 = [Afi_y2 zeros([size(Afi_y2,1),size(Bfi_y,2)]);
          -Cfi_y zeros(size(Cfi_y,1))];

Afi_y_a=[];
Afi_y_a(:,:,1) = Afi_y_a1;
Afi_y_a(:,:,2) = Afi_y_a2;
 
Bfi_y_a = [Bfi_y;-Dfi_y];

Cfi_y_a = [Cfi_y zeros(size(Cfi_y,1))];
%% VARIAVEL THETA-X
Atheta_x1 = [0 1 0 0;
       -wtheta^2 -2*zetatheta*wtheta 0 0;
          0 0 0 1;
          g 0 0 -Cx1];
Atheta_x2 = [0 1 0 0;
       -wtheta^2 -2*zetatheta*wtheta 0 0;
          0 0 0 1;
          g 0 0 -Cx2];
      
Btheta_x = [0;Ktheta*thetamax*wtheta^2;0;0];

Ctheta_x = [0 0 1 0];
Dtheta_x = [0];

Atheta_x_a1 = [Atheta_x1 zeros([size(Atheta_x1,1),size(Btheta_x,2)]);
              -Ctheta_x zeros(size(Ctheta_x,1))];
Atheta_x_a2 = [Atheta_x2 zeros([size(Atheta_x2,1),size(Btheta_x,2)]);
              -Ctheta_x zeros(size(Ctheta_x,1))];

Atheta_x_a=[];
Atheta_x_a(:,:,1) = Atheta_x_a1;
Atheta_x_a(:,:,2) = Atheta_x_a2;          
          
Btheta_x_a = [Btheta_x;-Dtheta_x];

Ctheta_x_a = [Ctheta_x zeros(size(Ctheta_x,1))];
%% ===============================================
%%  ========= PROJETO DOS CONTROLADORES ===========
%%  ===============================================
%% ================ MATRIZES DE PONDERACAO Q e R ====================
% VARIAVEL Z
Qz = [1 0 0;
      0 1 0;
      0 0 120]; %120
Rz = 1; %17
% VARIAVEL PSI
Qpsi = [1 0 0;
        0 1 0;
        0 0 0.01]; %1
Rpsi = 24.5; %15
% VARIAVEL FI-Y
Qfi_y = [1 0 0 0 0;
         0 1 0 0 0;
         0 0 1 0 0;
         0 0 0 1 0;
         0 0 0 0 240];%240
Rfi_y = 0.1;%0.1
% VARIAVEL THETA-X
Qtheta_x = [1 0 0 0 0;
            0 1 0 0 0;
            0 0 1 0 0;
            0 0 0 1 0;
            0 0 0 0 1000];
Rtheta_x = 3;
%% CALCULO DO GANHO K AUMENTADO - VIA LMI
disp('CONTROLE VIA LMI')
%Estado inicial
x0 = [1 1 1]';

alfa = 0; beta = 3; theta = 45; %Alocacao de Polos
K_z2 = lqrrobusto(Az_a,Bz_a,Cz_a,Dz,Qz,Rz,x0,alfa,beta,theta)

alfa = 0.4; beta = 4; theta = 60; %Alocacao de Polos
K_psi2 = lqrrobusto(Apsi_a,Bpsi_a,Cpsi_a,Dpsi,Qpsi,Rpsi,x0,alfa,beta,theta)

%Estado inicial
x0 = [1 1 1 1 1]';

alfa = 0.05; beta = 22; theta = 85; %Alocacao de Polos
Kfi_y2 = lqrrobusto(Afi_y_a,Bfi_y_a,Cfi_y_a,Dfi_y,Qfi_y,Rfi_y,x0,alfa,beta,theta)

alfa = 0.05; beta = 22; theta = 85; %Alocacao de Polos
Ktheta_x2 = lqrrobusto(Atheta_x_a,Btheta_x_a,Ctheta_x_a,Dtheta_x,Qtheta_x,Rtheta_x,x0,alfa,beta,theta)

%% =============================================================
%  ===== GANHO DE REALIMENTACAO DE ESTADO E INTEGRAL ===========
%  =============================================================
%% Z
Ki_z = K_z2(:,3);
K_z = K_z2(:,1:2);
%% PSI
Ki_psi = K_psi2(:,3);
K_psi = K_psi2(:,1:2);
%% FI-Y
Ki_fi_y = Kfi_y2(:,5);
Kfi_y = Kfi_y2(:,1:4);
%% THETA-X
Ki_theta_x = Ktheta_x2(:,5);
Ktheta_x = Ktheta_x2(:,1:4);
%% PARAMETROS VARIAVEIS
%% Limite Inferior
tz = tz1;
tpsi = tpsi1;
Cx = Cx1;
Cy = Cy1;
%% Limite Superior
tz = tz2;
tpsi = tpsi2;
Cx = Cx2;
Cy = Cy2;

%% Valor escolhido
tz = 0.4;
tpsi = 0.3;
Cx = 0.3;
Cy = 0.1;


%% Executar arquivo .slx
sim('Malha_de_Controle_Drone')

%% =============================================================
%% ================ SISTEMA EM MALHA FECHADA ===================
%% =============================================================
%% Tamanho da Fonte
fontsize = 20;
fontsize2 = 18;
%% Z
Af_z = [Az1+Bz1*K_z Bz1*Ki_z;
        -(Cz+Dz*K_z) -Dz*Ki_z];
Bf_z = [zeros(size(Az1,1),1);eye(1,1)];
Cf_z = [Cz+Dz*Kz Dz*Ki_z];
Df_z = Dz;

SYSz = ss(Af_z,Bf_z,Cf_z,Df_z);
polosZ = eig(Af_z)
%% PSI
Af_psi = [Apsi1+Bpsi1*K_psi Bpsi1*Ki_psi;
        -(Cpsi+Dpsi*K_psi) -Dpsi*Ki_psi];
Bf_psi = [zeros(size(Apsi1,1),1);eye(1,1)];
Cf_psi = [Cpsi+Dpsi*Kpsi Dpsi*Ki_psi];
Df_psi = Dpsi;

SYSpsi = ss(Af_psi,Bf_psi,Cf_psi,Df_psi);
polosPSI = eig(Af_psi)
%% FI
Af_fi = [Afi_y1+Bfi_y*Kfi_y Bfi_y*Ki_fi_y;
        -(Cfi_y+Dfi_y*Kfi_y) -Dfi_y*Ki_fi_y];
Bf_fi = [zeros(size(Afi_y1,1),1);eye(1,1)];
Cf_fi = [Cfi_y+Dfi_y*Kfi_y Dfi_y*Ki_fi_y];
Df_fi = Dfi_y;

SYSfi = ss(Af_fi,Bf_fi,Cf_fi,Df_fi);
polosFI = eig(Af_fi)
%% THETA
Af_theta = [Atheta_x1+Btheta_x*Ktheta_x Btheta_x*Ki_theta_x;
        -(Ctheta_x+Dtheta_x*Ktheta_x) -Dtheta_x*Ki_theta_x];
Bf_theta = [zeros(size(Atheta_x1,1),1);eye(1,1)];
Cf_theta = [Ctheta_x+Dtheta_x*Ktheta_x Dtheta_x*Ki_theta_x];
Df_theta = Dtheta_x;

SYStheta = ss(Af_theta,Bf_theta,Cf_theta,Df_theta);
polosTHETA = eig(Af_theta)

%% ====================== PZMAP =============================

%% Z
figure
pzplot(SYSz,'r')

%Ajustes
title('Polos de Malha Fechada do Sistema','FontSize',fontsize)
%Configura��es
xlabel('Eixo Real','FontSize',fontsize)
ylabel('Eixo Imagin�rio','FontSize',fontsize)
grid on
hm = findobj(gca, 'Type', 'Line');          % Handle To 'Line' Objects
hm(2).MarkerSize = 20;                      % �Zero� Marker
hm(3).MarkerSize = 20;                      % �Pole� Marker
hm(2).LineWidth = 5;                      % �Zero� Marker
hm(3).LineWidth = 5;                      % �Pole� Marker
%% PSI
hold on
pzplot(SYSpsi,'b')
hm = findobj(gca, 'Type', 'Line');          % Handle To 'Line' Objects
hm(2).MarkerSize = 20;                      % �Zero� Marker
hm(3).MarkerSize = 20;                      % �Pole� Marker
hm(2).LineWidth = 5;                      % �Zero� Marker
hm(3).LineWidth = 5;                      % �Pole� Marker

%% FI
hold on
pzplot(SYSfi,'k')
hm = findobj(gca, 'Type', 'Line');          % Handle To 'Line' Objects
hm(2).MarkerSize = 20;                      % �Zero� Marker
hm(3).MarkerSize = 20;                      % �Pole� Marker
hm(2).LineWidth = 5;                      % �Zero� Marker
hm(3).LineWidth = 5;                      % �Pole� Marker

%% THETA
hold on
pzplot(SYStheta,'m')
hm = findobj(gca, 'Type', 'Line');          % Handle To 'Line' Objects
hm(2).MarkerSize = 20;                      % �Zero� Marker
hm(3).MarkerSize = 20;                      % �Pole� Marker
hm(2).LineWidth = 5;                      % �Zero� Marker
hm(3).LineWidth = 5;                      % �Pole� Marker

legend('Subsistema z','Subsistema \psi','Subsistema \phi','Subsistema \theta')


%% =============================================================
%%  ================== RESULTADOS DA SIMULA��O ==================
%%  =============================================================
%% ===============> Plot da Trajet�ria em 3D <===================
if tipo == 1
    %REFER�NCIA CIRCULAR
    figure
    t = tout;
    xref = sin(0.8*t);
    yref = cos(0.8*t);
    zref = 1.2*ones([1 length(t)]);
    psiref = 0;
    plot3(xref,yref,zref,'r','LineWidth',2);
    title('Trajet�ria Circular','FontSize',fontsize)
    
    xref = sin(0.8*t-0.65);
    yref = cos(0.8*t-0.65);
else
    %REFER�NCIA OITO INCLINADO
    figure
    t = tout;
    xref = 0.5*sin(0.8*t);
    yref = sin(0.4*t);
    zref = 1.2 + 0.5*sin(0.4*t);
    psiref = -((pi/6)*sin(0.4*t));
    plot3(xref,yref,zref,'r','LineWidth',2);
    title('Trajet�ria em Formato de Oito Inclinado','FontSize',fontsize)
    
    xref = 0.5*sin(0.8*t-0.65);
    yref = sin(0.4*t-0.33);
    zref = 1.2 + 0.5*sin(0.4*t-0.4);
    psiref = -((pi/6)*sin(0.4*t+0.9));
end

%Simula��o
hold on
plot3(x,y,z,'LineWidth',2);
xlabel('Eixo x','FontSize',fontsize)
ylabel('Eixo y','FontSize',fontsize)
zlabel('Eixo z','FontSize',fontsize)
lgd = legend('Trajet�ria Refer�ncia','Trajet�ria Realizada pelo Drone')
lgd.FontSize = fontsize2;
grid on
axis([-1.5 1.5 -1.5 1.5 0 2.2]) %Ajuste do Gr�fico
% ==================================================================
%% TEMPOR�RIO
%return
%close all


%% Plot dos Sinais de Saida e Sinais de Controle Individuais 
%% X
figure
plot(tout,x,'b','LineWidth',2)
hold on
plot(t,xref,'r','LineWidth',2)
lgd = legend('X da simula��o','X de refer�ncia')
lgd.FontSize = fontsize2;
title('Sa�da X','FontSize',fontsize)
grid on
axis([0 20 -3 3])
xlabel('Tempo (s)','FontSize',fontsize)
ylabel('Posi��o x (m)','FontSize',fontsize)

figure
plot(tout,u_theta,'LineWidth',2)
title('Sinal de Controle - U_{\theta}','FontSize',fontsize)
grid on
%% Y
figure
plot(tout,y,'b','LineWidth',2)
hold on
plot(t,yref,'r','LineWidth',2)
lgd = legend('Y da simula��o','Y de refer�ncia','FontSize',fontsize)
lgd.FontSize = fontsize2;
title('Sa�da Y','FontSize',fontsize)
grid on
axis([0 20 -1.5 1.5])
xlabel('Tempo (s)','FontSize',fontsize)
ylabel('Posi��o y (m)','FontSize',fontsize)

figure
plot(tout,u_fi,'LineWidth',2)
title('Sinal de Controle - U_{\phi}','FontSize',fontsize)
grid on
%% Z
figure
plot(tout,z,'b','LineWidth',2)
hold on
plot(t,zref,'r','LineWidth',2)
lgd = legend('Z da simula��o','Z de refer�ncia','FontSize',fontsize)
lgd.FontSize = fontsize2;
title('Sa�da Z','FontSize',fontsize)
grid on
xlabel('Tempo (s)','FontSize',fontsize)
ylabel('Posi��o z (m)','FontSize',fontsize)
axis([0 10 0 1.5]) %circulo
axis([0 30 0 1.8]) %oito
 
figure
plot(tout,uz,'LineWidth',2)
title('Sinal de Controle - Uz','FontSize',fontsize)
grid on

%% PSI
figure
plot(tout,e_psi,'b','LineWidth',2)
hold on
plot(t,psiref,'r','LineWidth',2)
lgd = legend('\psi da simula��o','\psi de refer�ncia')
lgd.FontSize = fontsize2;
title('Sa�da \psi','FontSize',fontsize)
grid on
xlabel('Tempo (s)','FontSize',fontsize)
ylabel('�ngulo \psi (rad)','FontSize',fontsize)
axis([0 30 -0.6 0.6])

figure
plot(tout,u_psi,'LineWidth',2)
title('Sinal de Controle - U_{\psi}','FontSize',fontsize)
grid on