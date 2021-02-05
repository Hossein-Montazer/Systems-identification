clc;clear;close all
load A.mat
load D.mat
load E.mat

d=input('Please Enter Reducted Dimention:   ');
Dyn=input('Please Enter Number Of Dynamics:(for example 0 for original data)   ') + 1;
X_Train_All={A(1:3000,:),D(1:3000,:),E(1:3000,:)};
X_Test_All={A(3001:end,:),D(3001:end,:),E(3001:end,:)};

% X_Test_All{1}(:,94)=X_Test_All{1}(:,94)*0;
% X_Test_All{2}(:,94)=X_Test_All{2}(:,94)*0;
% X_Test_All{3}(:,94)=X_Test_All{3}(:,94)*0;
%%
ClassNo=size(X_Train_All,2);
%%
for i=1:ClassNo
    [ X_Train_All{i},X_Test_All{i} ] = Dynamic( X_Train_All{i},X_Test_All{i},Dyn );
end

%%
[n p]=size(X_Train_All{1});
G=cell(1,ClassNo-1);
Z_train=cell(1,ClassNo);
Z_test=cell(1,ClassNo);

%% LDA 
if d<=ClassNo-1
    [ G , E ] = LDA( X_Train_All , ClassNo , d );


    %%
    disp('Fisher Critria=')
    disp(E)
    %%

    for i=1:ClassNo
        Z_train{i}=G*X_Train_All{i}';
        Z_test{i}=G*X_Test_All{i}';
    end
    %%
    if d==2
        figure
        plot(Z_train{1}(1,:),Z_train{1}(2,:),'*')
        hold on
        plot(Z_train{2}(1,:),Z_train{2}(2,:),'r+')
        hold on
        plot(Z_train{3}(1,:),Z_train{3}(2,:),'go')
        hold off
        grid on
        legend('First Class','Second Class','Third Class');
    else
        figure
        plot(Z_train{1}(1,:),'*')
        hold on
        plot(Z_train{2}(1,:),'r+')
        hold on
        plot(Z_train{3}(1,:),'go')
        hold off
        grid on
        legend('First Class','Second Class','Third Class');
    end
    title('Train Features After LDA')
    if d==2
        figure
        plot(Z_test{1}(1,:),Z_test{1}(2,:),'*')
        hold on
        plot(Z_test{2}(1,:),Z_test{2}(2,:),'r+')
        hold on
        plot(Z_test{3}(1,:),Z_test{3}(2,:),'go')
        hold off
        grid on
        legend('First Class','Second Class','Third Class');
    else
        figure
        plot(Z_test{1}(1,:),'*')
        hold on
        plot(Z_test{2}(1,:),'r+')
        hold on
        plot(Z_test{3}(1,:),'go')
        hold off
        grid on
        legend('First Class','Second Class','Third Class');
    end
    title('Test Features After LDA')
    %%
    W_opt = Classifier_LS( Z_train , ClassNo );


    %%
    Confidence=Confidence( W_opt,Z_test,ClassNo )

    %%
    
else
    disp('Your requested dimention is not valid')
end
