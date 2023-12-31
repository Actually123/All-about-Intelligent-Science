load census
plot(cdate,pop,'o')
fo = fitoptions('Method','NonlinearLeastSquares',...
               'Lower',[0,0],...
               'Upper',[Inf,max(cdate)],...
               'StartPoint',[1 1]);
ft = fittype('a*(x-b)^n','problem','n','options',fo);
[curve1,gof1] = fit(cdate,pop,ft,'problem',1)
[curve2,gof2] = fit(cdate,pop,ft,'problem',2)
[curve3,gof3] = fit(cdate,pop,ft,'problem',3)
hold on
plot(curve1,'r')
plot(curve2,'m')
plot(curve3,'c')
legend('Data','n=1','n=2','n=3')
hold off

load carsmall
x1 = Weight;
x2 = Horsepower;    % Contains NaN data
y = MPG;
X = [ones(size(x1)) x1 x2 x1.*x2];
b = regress(y,X)    % Removes NaN data
scatter3(x1,x2,y,'filled')
hold on
x1fit = min(x1):100:max(x1);
x2fit = min(x2):10:max(x2);
[X1FIT,X2FIT] = meshgrid(x1fit,x2fit);
YFIT = b(1) + b(2)*X1FIT + b(3)*X2FIT + b(4)*X1FIT.*X2FIT;
mesh(X1FIT,X2FIT,YFIT)
xlabel('Weight')
ylabel('Horsepower')
zlabel('MPG')
view(50,10)
hold off