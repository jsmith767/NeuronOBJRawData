function Neuron = getVoxByIterationShort(scaling,IL,SLA,Vertices,Faces,name)

    allIL = vertcat(IL{:,:});%concatenate group
    mIL = max(allIL);%finds the longest iteration for all the neurons branches

    %Initialize the Neuron Structure
    Neuron = struct('name','','iteration',[],'path','','vertices',[],'faces',[],'voxCoords',[],'SLA',[],'IL',[],'voxUnique',[]);

%     %set the path to the Neuron
%     path = pwd;
%     path = fullfile(path,[name '.obj']);

%     [Vertices, ~, Faces, ~] = ReadOBJtest(path); % Get vertex and face data

    %find the overall range 
    AllV = vertcat(Vertices{:,:});
    [AllV,~] = makeBoundingBox(AllV,vertcat(Faces{:,:}),AllV);
    xrange = max(AllV(:,1)) - min(AllV(:,1));
    yrange = max(AllV(:,2)) - min(AllV(:,2));
    zrange = max(AllV(:,3)) - min(AllV(:,3));

    %writes some Neuron data
    Neuron(mIL).iteration = mIL;
    Neuron(mIL+1).name = 'boundingBox';
    for i=1:length(Neuron)
        Neuron(i).name = name;
        Neuron(i).path = path;
    end

    for m=1:length(Vertices)

        [V,F] = makeBoundingBox(Vertices{m},Faces{m},AllV);

        Neuron(max(IL{m})).vertices{m} = V;
        Neuron(max(IL{m})).faces{m} = F;

        N.vertices = V;
        N.faces = F;

        % Get x,y,z data of 
        TempVox = VOXELISE(round(xrange*scaling), round(yrange*scaling), round(zrange*scaling), N);
        TempInd = find(TempVox);
        [TempX, TempY, TempZ] = ind2sub(size(TempVox),TempInd);
        Neuron(max(IL{m})).voxCoords{m} = [TempX,TempY,TempZ];
        Neuron(max(IL{m})).SLA{m} = SLA{m};
        Neuron(max(IL{m})).IL{m} = IL{m};

        for i =max(IL{m})-1:-1:1
            Neuron(i).iteration = i;
            cutV = [];
            cutBN = find(IL{m}==i+1); %cutBranchNumber, the number of the branch in the SLA matrix we will cut
            cutV(:,1) = SLA{m}(cutBN-1,2)*16+1;
            cutV(:,2) = SLA{m}(cutBN,2)*16;
%             cutVInd=[];
            Neuron(i).vertices{m}=Neuron(i+1).vertices{m};
            Neuron(i).faces{m}=Neuron(i+1).faces{m};
            for j = size(cutV,1):-1:1
                cutVInd = (cutV(j,1):cutV(j,2))';
                Neuron(i).vertices{m}(cutVInd,:)=[];
                for k = 1:length(cutVInd)
                    Neuron(i).faces{m}(any(Neuron(i).faces{m}==cutVInd(k),2),:)=[];
                end
                Neuron(i).faces{m}(Neuron(i).faces{m} >= cutV(j,1)) = Neuron(i).faces{m}(Neuron(i).faces{m} >= cutV(j,1))-length(cutVInd);
                SLA{m}(cutBN(j):end,2) = SLA{m}(cutBN(j):end,2)-(SLA{m}(cutBN(j),2)-SLA{m}(cutBN(j)-1,2)); %Adjust the SLA matrix 
                SLA{m}(cutBN(j),:) = [];
                IL{m}(cutBN(j)) = [];
            end

            N.vertices = Neuron(i).vertices{m};
            N.faces = Neuron(i).faces{m};

            TempVox = VOXELISE(round(xrange*scaling), round(yrange*scaling), round(zrange*scaling), N);
            TempInd = find(TempVox);
            [TempX, TempY, TempZ] = ind2sub(size(TempVox),TempInd);
            Neuron(i).voxCoords{m} = [TempX,TempY,TempZ];
            %translate the result
        %     Neuron(i).voxCoords = Neuron(i).voxCoords - (Neuron(i).voxCoords(1,:)-Neuron(i+1).voxCoords(1,:));

            Neuron(i).SLA{m} = SLA{m};
            Neuron(i).IL{m} = IL{m};


            Neuron(i+1).voxUnique{m} = Neuron(i+1).voxCoords{m}(~ismember(Neuron(i+1).voxCoords{m},Neuron(i).voxCoords{m},'rows'),:);
            Neuron(i+1).voxUAll = vertcat(Neuron(i+1).voxUnique{:,:});
            if i==1
                Vbox = Neuron(1).vertices{m}(end-23:end,:);
                Fbox = Neuron(1).faces{m}(end-23:end,:);
                Fbox = Fbox-min(min(Fbox))+1;
                Neuron(mIL+1).vertices{1} = Vbox;
                Neuron(mIL+1).faces{1} = Fbox;
                Bbox.vertices = Vbox;
                Bbox.faces = Fbox;
                TempVox = VOXELISE(round(xrange*scaling), round(yrange*scaling), round(zrange*scaling), Bbox);
                TempInd = find(TempVox);
                [TempX, TempY, TempZ] = ind2sub(size(TempVox),TempInd);
                Neuron(mIL+1).voxCoords{m} = [TempX,TempY,TempZ];
                Neuron(1).voxUnique{m} = Neuron(1).voxCoords{m}(~ismember(Neuron(1).voxCoords{m},Neuron(mIL+1).voxCoords{m},'rows'),:);
                Neuron(1).voxUAll = vertcat(Neuron(1).voxUnique{:,:});
            end
        end
    end
end
%find the unique voxels for iterations 2:end 
% for i=length(Neuron):-1:2
% Neuron(i).voxUnique = Neuron(i).voxCoords(~ismember(Neuron(i).voxCoords,Neuron(i-1).voxCoords,'rows'),:);
% end
%find the unique voxels for the first iteration
% V{1} = Neuron(1).vertices(end-23:end,:);
% F{1} = Neuron(1).faces(end-23:end,:);
% F{1} = F{1}-min(F{1}(1,1))+1;
% Neuron(length(Neuron)+1).vertices = vertcat(V{:,:});
% Neuron(length(Neuron)).faces = vertcat(F{:,:});
% TempVox = VOXELISE(round(xrange*scaling), round(yrange*scaling), round(zrange*scaling), Neuron(length(Neuron)));
% TempInd = find(TempVox);
% [TempX, TempY, TempZ] = ind2sub(size(TempVox),TempInd);
% Neuron(length(Neuron)).voxCoords = [TempX,TempY,TempZ];
% Neuron(1).voxUnique = Neuron(1).voxCoords(~ismember(Neuron(1).voxCoords,Neuron(23).voxCoords,'rows'),:);


% for i=1:length(Neuron)
% %Clean the reference points
% Neuron(i).voxCoords(1,:) = [];
% Neuron(i).vertices(end,:) = [];
% end