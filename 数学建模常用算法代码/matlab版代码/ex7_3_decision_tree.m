%%CART�������㷨Matlabʵ��
clear all;
close all;
clc;
load fisheriris  %������������
t = fitctree(meas,species,'PredictorNames',{'SL' 'SW' 'PL' 'PW'})%��������������ʾ����
view(t) %�������д��������ı���ʾ�������ṹ
view(t,'Mode','graph') %ͼ����ʾ�������ṹ
