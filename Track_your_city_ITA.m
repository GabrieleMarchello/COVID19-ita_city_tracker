clear all
close all
clc

folder_prov=strcat(pwd,'\COVID-19-master\dati-province\');

patt_prov=fullfile(folder_prov,'*.csv');
files_prov=dir(patt_prov);
giorni=length(files_prov);    % number of files

c1=[255,140,0]/255;
c2=[230,140,240]/255;

citt_name={'Bergamo'};

for e=1:length(citt_name)
    
    cnt=0;
    
    for i=1:giorni

            if strcmp(files_prov(i).name(end-11:end-8),'2020')

                cnt=cnt+1;
                [tot_citt(cnt),tot_reg(cnt),reg{e},x(i,:)]=find_reg(folder_prov,files_prov(i).name,citt_name{e});

                if cnt>1
                    diff_citt(cnt)=tot_citt(cnt)-tot_citt(cnt-1);
                    diff_reg(cnt)=tot_reg(cnt)-tot_reg(cnt-1);
                else
                    diff_citt(cnt)=0;
                    diff_reg(cnt)=0;
                end
            end

    end
        
    figure, subplot(1,2,1), plot([1:cnt],tot_reg,'Color',c1,'LineWidth',3)
    hold on
    plot([1:cnt],tot_citt,'Color',c2,'LineWidth',3)
    ax=gca;
    ax.Color='k';
    xticks(1:3:length(x))
    xticklabels(x(1:3:end,:))
    xtickangle(30);
    ylabel('N of cases')
    title('Total cases')
    lg1=legend(char(reg{e}),citt_name{e},'Location','northwest');
    lg1.TextColor='white';
    lg1.Box='off';
    lg1.FontSize=14;
    grid on
    subplot(1,2,2), plot([1:cnt],diff_reg,'o','MarkerEdgeColor',c1,'MarkerFaceColor',c1,'LineWidth',2)
    hold on
    plot([1:cnt],diff_citt,'o','MarkerEdgeColor',c2,'MarkerFaceColor',c2,'LineWidth',2)
    ax=gca;
    ax.Color='k';
    xticks(1:3:length(x))
    xticklabels(x(1:3:end,:))
    xtickangle(30);
    ylabel('N of cases')
    title('Daily increment')
    lg2=legend(char(reg{e}),citt_name{e},'Location','northwest');
    lg2.TextColor='white';
    lg2.Box='off';
    lg2.FontSize=14;
    grid on
    
end






function [citt_tot,reg_tot,p_reg,t]=find_reg(folder,filename,citt)

    fileID=fopen(strcat(folder,filename));
    data=textscan(fileID,'%s %s %d %s %d %s %s %f %f %d','Delimiter',',','HeaderLines',1);
    fclose(fileID);
    
    p_citt=find(contains(data{6},citt));
    citt_tot=data{end}(p_citt);
    
    p_reg=data{4}(p_citt);
    
    reg=find(contains(data{4},p_reg));
    reg_tot=sum(data{end}(reg(1:end-1)));
    
    t=char(data{1});
    t=t(1,6:10);
    
end