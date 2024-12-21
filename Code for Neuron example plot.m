%%%% load "Example_..." files in "Data" folder.

% following could adjust as needed
pre_data_time=-100;
post_data_time=100;
pre_lim_time=-300;
post_lim_time=300;
FSN=4;
REP=20;   % number of trial
bin_size=50;
bin_step=5;
PSTH_Y_LIM=110;

% following will auto-adjust when the upper change
pre_lim_time1=350+pre_lim_time+1;
post_lim_time1=350+post_lim_time+1;
bin_lim_num=(post_lim_time1-pre_lim_time1)/bin_step+1;
bin_data_pre=(bin_lim_num-1)/2+pre_data_time/5+1;
bin_data_post=(bin_lim_num-1)/2+post_data_time/5+1;

%%%% Mem
for M=1:FSN
    spike{M}=SeqData.SingleSaccOn_Spike{1,M+4};
    for bin_num=1:bin_lim_num    
        for trial=TrialStart:REP
            raster(trial+(M-1)*REP,:)=spike{M}(trial,pre_lim_time1:post_lim_time1);
            raster1{M}(trial,:)=spike{M}(trial,pre_lim_time1:post_lim_time1);
            binspike1(trial+(M-1)*REP,bin_num)=mean(spike{M}(trial,(bin_step*(bin_num-1)+pre_lim_time1-bin_size/2):(bin_step*(bin_num-1)+pre_lim_time1+bin_size/2)))*1000;
        end
        binspike(M,bin_num)=nanmean(binspike1((M-1)*REP+1:M*REP,bin_num));
    end
end

for M =1:FSN
    for trial =TrialStart:REP
        raster_time1{M,trial,:}=find(raster1{M}(trial,:)==1);
    end
end


FigureIndex=2;
figure(FigureIndex);set(FigureIndex,'Position', [100,100 1500,800]);
%%%% raster
for M =1:FSN
    h1=axes('position',[0.03+(M-1)*0.23 0.688 0.18 0.16]);
    x1=[pre_data_time:post_data_time];
    y1=ones(1,201)*REP;
    area(x1,y1);
    set(h1,'XLim',[pre_lim_time,post_lim_time],'XTick',[],'YLim',[0,REP],'YTick',[]);
    hold on
    
    for trial =TrialStart:REP
        h2=axes('position',[0.03+(M-1)*0.23 0.84-(trial-1)*0.008 0.18 0.008]);
        raster_time=find(raster(trial+(M-1)*REP,:)==1);
        raster_time=raster_time(find(raster_time >0));
        x_spks=[1;1]*raster_time/1000;
        y_spks=[zeros(1,length(raster_time));ones(1,length(raster_time))];
        line(x_spks,y_spks,'Color','k');
        set(h2,'YLim',[0,1],'xlim',[0,(post_lim_time-pre_lim_time)/1000]);
        axis off
    end

end
%%%% PSTH
for M =1:FSN
        h=axes('position',[0.03+(M-1)*0.23 0.38 0.18 0.2]);
        x=[pre_lim_time:bin_step:post_lim_time];
        y=binspike(M,:);
        x1=[pre_data_time:bin_step:0];
        y1=binspike(M,bin_data_pre:61);
        area(x,y,'facecolor','k');
        set(h,'XLim',[pre_lim_time,post_lim_time],'YLim',[0,PSTH_Y_LIM],'YTick',[0,PSTH_Y_LIM/2,PSTH_Y_LIM]);
        hold on
        area(x1,y1);
        set(h,'XLim',[pre_lim_time,post_lim_time],'XTick',[pre_lim_time,0,post_lim_time],'YLim',[0,PSTH_Y_LIM],'YTick',[0,PSTH_Y_LIM/2,PSTH_Y_LIM]);
end
