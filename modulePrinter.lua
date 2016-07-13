local Printer, _ = torch.class('nn.Printer', 'nn.Module')

function Printer:__init(str, print_input)
   self.string = str
   self.print_input = print_input or false
end

function Printer:print(input)
   if self.print_input == 'size' then
      if torch.isTensor(input) then
	 print(input:size())
      else
	 print('Input is a table, getting the length is more complicated')
	 print('First dimension length is: ' .. #input)
      end
   elseif self.print_input then
      print(input)
   end
end

function Printer:updateOutput(input)
   print('Forward pass: ' .. self.string)
   self:print(input)

   self.output = input
   return self.output
end


function Printer:updateGradInput(input, gradOutput)
   print('Backward pass:' .. self.string)
   self:print(input)
   
   self.gradInput = gradOutput
   return self.gradInput
end

function Printer:clearState()
   -- don't call set because it might reset referenced tensors
   local function clear(f)
      if self[f] then
         if torch.isTensor(self[f]) then
            self[f] = self[f].new()
         elseif type(self[f]) == 'table' then
            self[f] = {}
         else
            self[f] = nil
         end
      end
   end
   clear('output')
   clear('gradInput')
   return self
end
