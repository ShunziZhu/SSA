function [y,rmse,Lo,po]=ssa_interpolation3(x,start,num,e)%���Σ�start�����Ϊԭʼ�����е���ţ��Ҵ�С�������У�xΪѵ�����ݣ��ö���;e�˳�ѭ������ֵ,startΪȱʧ���ݵ�ǰһ��
    %ѡȡ���Ų���
    L=1;p=1;rmse=0;
    Lmax=floor(length(x+sum(num))/2);
    xn=0;xn2=0;xa=0;cross=0;xr=0;xr2=0;rmse1=0;
    xa=mean(x);
    for i=1:length(x)%ȥ���Ļ�
    	xn(i)=x(i)-xa; %xnΪȥ���Ļ��������
    end
    %ѡȡ������֤����
    cross=1+round((length(xn)-1)*rand(1,round(length(xn)/10)));
    for i=1:size(cross,2)
    	cross(2,i)=xn(cross(1,i));
    	xn(cross(1,i))=0;
    end
    xn=xn';
    for j=1:length(start)
    	xn=[xn(1:start(j));zeros(num(j),1);xn((start(j)+1):length(xn))];%������ݸ�0
    	for i=1:size(cross,2)
            if cross(1,i)>start(j)
            	cross(1,i)=cross(1,i)+num(j);
            end
    	end
    end
	xn2=xn;
    
    for L=1:Lmax
        for p=1:L
            xn=xn2;xr=0;rmse1=0;xr2=0;
            while 1
                xr=ssa_ip(xn,L,p);
                for i=1:size(cross,2)
                	xn(cross(1,i))=xr(cross(1,i));
                end
                for j=1:length(start)
                    for i=(start(j)+1):(start(j)+num(j))
                        xn(i)=xr(i);
                    end
                end
                m=max(abs(xr2-xr));
                if m>max(abs(x))
                    L
                    p
                    break;
                end
                if m<=e
                    m
                    break;
                end
                xr2=xr;%xr2Ϊ��ǰ�ģ�xrΪ���ڵ�
            end
            
            xn=xn+xa;
            for i=1:size(cross,2)
                rmse1=rmse1+(xn(cross(1,i))-cross(2,i))*(xn(cross(1,i))-cross(2,i));
            end
            rmse1=sqrt(rmse1/size(cross,2));
            rmse(L,p)=rmse1;
            
        end
    end
    Lo=1;po=1;%�ҵ���ѵ�L��p
    rmsemin=rmse(1,1);
    for i=1:size(rmse,1)
       for j=1:size(rmse,2)
           if j<=i
               if rmse(i,j)<rmsemin
                   rmsemin=rmse(i,j);
                   Lo=i;
                   po=j;
               end
           end
       end
    end
    

    xn=0;xn2=0;xa=0;xr=0;xr2=0;%��ʼ�岹
    xa=mean(x);
    for i=1:length(x)%ȥ���Ļ�
       xn(i)=x(i)-xa; %xnΪȥ���Ļ��������
    end
    xn=xn';
    for j=1:length(start)
        xn=[xn(1:start(j));zeros(num(j),1);xn((start(j)+1):length(xn))];%������ݸ�0
    end


    while 1
        xr=ssa_ip(xn,Lo,po);
        for j=1:length(start)
            for i=(start(j)+1):(start(j)+num(j))
                xn(i)=xr(i);
            end
        end
    	m=max(abs(xr2-xr));
        if m<=e
        	break;
        end
        xr2=xr;%xr2Ϊ��ǰ�ģ�xrΪ���ڵ�
     end
     y=xn+xa;
    
end