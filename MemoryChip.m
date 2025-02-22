classdef CPU
    properties (Access=private)
        totalMemory
        dataWidth
        banks
        bankSize
        memory
    end
    methods (Static)
        function main
            clear; clc;
            c = CPU(1024,8,4);
            for i = 1:10
                a = c.generateAddress();
                c = c.write(a, randi([0,255]));
                disp(['0x' dec2hex(a) ' ' num2str(c.read(a))])
            end
        end
    end
    methods
        function obj = CPU(tm,dw,b)
            obj.totalMemory = tm;
            obj.dataWidth = dw;
            obj.banks = b;
            obj.bankSize = tm/b;
            obj.memory = cell(b,1);
            for i = 1:b
                obj.memory{i} = zeros(obj.bankSize,1,'uint8');
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
        end
        function value = read(obj,addr)
            bank = floor((addr-1)/obj.bankSize) + 1;
            offset = mod(addr-1,obj.bankSize) + 1;
            value = obj.memory{bank}(offset);
        end
    end
end
