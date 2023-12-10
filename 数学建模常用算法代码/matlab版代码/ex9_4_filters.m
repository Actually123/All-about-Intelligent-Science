clear;clc;
fs = 6400;  % �ز���Ƶ��
T = 1/fs;  % ����
n = 5;  % 1HzƵ�ʱ��ֳ�n��
N = fs*n;  % ��Ϊ1HzƵ�ʱ��ֳ���n�Σ�����Ƶ�׵�x��������fs*n����
f = (0: N-1)*fs/N;  % ��fs��Ƶ��ϸ�ֳ�fs*n������ԭ����[0, 1, 2, ��, fs]��������[0, 1/N, 2/N, ��, (N-1)*fs/N]��
t = (0: N-1)*T;  % �ź���������ʱ����N�����ڣ�
nHz = 1000;  % ����Ƶ�׵ĺ����굽nHz
Hz = nHz*n;  % ����Ƶ�׵ĺ�������������
Wc=2*640/fs;
Wc1=2*512/fs;                                          %�½�ֹƵ�� 1Hz
Wc2=2*640/fs;
[b,a]=butter(2,[Wc1, Wc2],'bandpass');  % ���׵İ�����˹��ͨ�˲�

sr=xlsread('����1.xls',1 );
x=sr(:,3);
subplot(2,3,1);
plot(x(1:1000),'r');
xlabel("time");ylabel("sensor 1");title("ԭʼ�ź�");

b  =  [1 1 1 1 1 1]/6;
x1 = filter(b,1,x);
fprintf("�ƶ�ƽ���˲������\n");
-snr(x1,x-x1)
fprintf("���������\n");
rms(x-x1)
subplot(2,3,2);
plot(x1(1:1000),'r');
xlabel("time");ylabel("sensor 1");title("�ƶ�ƽ���˲�")

x1=medfilt1(x,10);
fprintf("��ֵ�˲������\n");
-snr(x1,x-x1)
fprintf("���������\n");
rms(x-x1)
subplot(2,3,3);
plot(x1(1:1000),'r');
xlabel("time");ylabel("sensor 1");title("��ֵ�˲�")

[b,a]=butter(4,Wc,'low');  % �Ľ׵İ�����˹��ͨ�˲�
x1=filter(b,a,x);
fprintf("��ͨ�˲������\n");
-snr(x1,x-x1)
fprintf("���������\n");
rms(x-x1)
subplot(2,3,4);
plot(x1(1:1000),'r');
xlabel("time");ylabel("sensor 1");title("��ͨ�˲�")


wpt = wpdec(x,3,'db1');
x1 = wpcoef(wpt,[2 1]);
fprintf("С�����˲������\n");
-snr(x1,x(1:7350)-x1)
fprintf("���������\n");
rms(x(1:7350)-x1)
subplot(2,3,5);
plot(x1(1:1000),'r'); 
xlabel("time");ylabel("sensor 1");title("С�����˲�")

[b,a]=butter(2,[Wc1, Wc2],'bandpass');  % ���׵İ�����˹��ͨ�˲�
x1=filter(b,a,x);
fprintf("��ͨ�˲������\n");
-snr(x1,x-x1)
fprintf("���������\n");
rms(x-x1)
subplot(2,3,6);
plot(x1(1:1000),'r');
xlabel("time");ylabel("sensor 1");title("��ͨ�˲�")





