classdef CPU
    properties (Access=private)
        totalMemory
        dataWidth
        banks
        bankSize
        memory
        occupied
    end
    methods (Static)
        function main
            clc; clear;
            c = CPU(1024,8,4);
            for i = 1:10
                a = c.generateAddress();
                c = c.write(a, randi([1,255]));
                disp(['0x' dec2hex(a) ' ' num2str(c.read(a))])
            end
            c.displayGraph();
        end
    end
    methods
        function obj = CPU(tm,dw,b)
            obj.totalMemory = tm;
            obj.dataWidth = dw;
            obj.banks = b;
            obj.bankSize = tm/b;
            obj.memory = cell(b,1);
            obj.occupied = cell(b,1);
            for i = 1:b
                obj.memory{i} = zeros(obj.bankSize,1,'uint8');
                obj.occupied{i} = false(obj.bankSize,1);
            end
        end
        function addr = generateAddress(obj)
            bank = randi(obj.banks);
            offset = randi(obj.bankSize);
            addr = (bank-1)*obj.bankSize + offset;
        end
        function obj = write(obj,addr,value)
            bank = floor((addr-1)/obj.bankSize) + 1;
            offset = mod(addr-1,obj.bankSize) + 1;
            obj.memory{bank}(offset) = uint8(value);
            obj.occupied{bank}(offset) = true;
        end
        function value = read(obj,addr)
            bank = floor((addr-1)/obj.bankSize) + 1;
            offset = mod(addr-1,obj.bankSize) + 1;
            value = obj.memory{bank}(offset);
        end
        function displayGraph(obj)
            occupancyMatrix = zeros(obj.bankSize, obj.banks);
            for i = 1:obj.banks
                occupancyMatrix(:,i) = double(obj.occupied{i});
            end
            figure; imagesc(occupancyMatrix);
            colormap([1 1 1; 0 0 0]);
            title('Memory Occupancy');
            xlabel('Bank');
            ylabel('Cell Index');
            set(gca,'XTick',1:obj.banks);
            axis equal tight;
        end
    end
end
