function D = Distance2(citys)
%% ������������֮��ľ���
% ����:�����еľ�γ������(citys)
% ���:��������֮��ľ���(D)
 
n = size(citys, 1);
D = zeros(n, n);
r = 6378.137;   %����뾶
for i = 1: n
    for j = i + 1: n
        D(i, j) = r * acosd( cosd( citys(i,1) - citys(j,1) )* cosd(citys(i, 2))* cosd(citys(j, 2))+ sind(citys(i,2))* sind(citys(j,2)) );
        D(j, i) = D(i, j);
    end
    D(i, i) = 1e-4;              %�Խ��ߵ�ֵΪ0�������ں������������Ҫȡ�����������һ����С������0
end