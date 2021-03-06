-- model definition module
require 'nn'	

local M = {}

function M:select_model(opt, dict_size)

	if opt.model == 'lookup_elad' then 

	    model = nn.Sequential()
	    model:add(nn.LookupTable(dict_size, 200))
		model:add(nn.TemporalConvolution(200, 300, 4, 1))
		model:add(nn.Tanh())
		model:add(nn.TemporalMaxPooling(3, 1))

		model:add(nn.TemporalConvolution(300, 300, 5, 2))
		model:add(nn.Tanh())
		model:add(nn.TemporalMaxPooling(3, 1))

	    model:add(nn.Reshape(300*44, true))	
	    model:add(nn.Linear(300*44, 5))
		model:add(nn.LogSoftMax())
		
	elseif opt.model=='elad' then
		
		model = nn.Sequential()
		model:add(nn.TemporalConvolution(200, 400, 10, 1))
		model:add(nn.ReLU())
		model:add(nn.TemporalMaxPooling(5,1))
		model:add(nn.Dropout(.5))
		model:add(nn.Reshape(400*87, true))
		model:add(nn.Linear(400*87, 100))
		model:add(nn.Linear(100, 5))
		model:add(nn.LogSoftMax())

	elseif opt.model=='mark' then
		
		model = nn.Sequential()
		model:add(nn.TemporalConvolution(200, 300, 8, 1))
		model:add(nn.ReLU())
		model:add(nn.TemporalMaxPooling(4,1))
		model:add(nn.Dropout(.5))
		model:add(nn.Reshape(300*90, true))
		model:add(nn.Linear(300*90, 200))
		model:add(nn.Linear(200, 5))
		model:add(nn.LogSoftMax())

	elseif opt.model == 'lookup_mark' then 

		model = nn.Sequential()
		model:add(nn.LookupTable(dict_size, 200))
		model:add(nn.TemporalConvolution(200, 400, 10, 1))
		model:add(nn.ReLU())
		model:add(nn.TemporalMaxPooling(5,1))
		model:add(nn.Dropout(.5))
		model:add(nn.Reshape(400*87, true))
		model:add(nn.Linear(400*87, 100))
		model:add(nn.Linear(100, 5))
		model:add(nn.LogSoftMax())

	elseif opt.model=='bigboy' then
		
		--bigrams
	    bigrams = nn.Sequential()
		bigrams:add(nn.TemporalConvolution(200, 250, 2, 1))
		bigrams:add(nn.ReLU())
		bigrams:add(nn.TemporalConvolution(250, 300, 2, 1))
		bigrams:add(nn.ReLU())
		bigrams:add(nn.TemporalMaxPooling(3, 1))
		bigrams:add(nn.TemporalConvolution(300, 300, 2, 1))
		bigrams:add(nn.ReLU())
		bigrams:add(nn.TemporalMaxPooling(4, 1))

	--	output=bigrams:forward(all_tr_data.x)
	--	print(#output)
		--10000
	    --22
	    --110	
		
		--trigrams
	    trigrams = nn.Sequential()
		trigrams:add(nn.TemporalConvolution(200, 250, 3, 1))
		trigrams:add(nn.ReLU())
		trigrams:add(nn.TemporalConvolution(250, 300, 3, 1))
		trigrams:add(nn.ReLU())
		trigrams:add(nn.TemporalMaxPooling(3, 1))
		trigrams:add(nn.TemporalConvolution(300, 300, 2, 1))
		trigrams:add(nn.ReLU())
		trigrams:add(nn.TemporalMaxPooling(2, 1))
		
	--	output=trigrams:forward(all_tr_data.x)
	--	print(#output)
		--10000
	    --22
	    --110

		--quadgrams
	    quadgrams = nn.Sequential()
		quadgrams:add(nn.TemporalConvolution(200, 250, 4, 1))
		quadgrams:add(nn.ReLU())
		quadgrams:add(nn.TemporalConvolution(250, 300, 4, 1))
		quadgrams:add(nn.ReLU())
		quadgrams:add(nn.TemporalMaxPooling(3, 1))
		
	--	output=quadgrams:forward(all_tr_data.x)
	--	print(#output)
		--10000
	    --22
	    --110
			
		par=nn.Concat(2)
		par:add(bigrams)
		par:add(trigrams)
		par:add(quadgrams)

	    model = nn.Sequential()
		model:add(par)
		
		model:add(nn.TemporalConvolution(300, 300, 4, 2))
		model:add(nn.ReLU())
		model:add(nn.TemporalMaxPooling(3, 2))
		
		model:add(nn.TemporalConvolution(300, 300, 4, 3))
		model:add(nn.ReLU())
		model:add(nn.TemporalMaxPooling(3, 1))

		model:add(nn.TemporalConvolution(300, 300, 2, 1))
		model:add(nn.ReLU())
		
		model:add(nn.Reshape(300, true))	
	    model:add(nn.Linear(300, 5))
		model:add(nn.LogSoftMax())
		

	elseif opt.model=='smallerboy' then
		
		--bigrams
	    bigrams = nn.Sequential()
		bigrams:add(nn.TemporalConvolution(50, 100, 2, 1))
		bigrams:add(nn.ReLU())
		bigrams:add(nn.TemporalMaxPooling(3, 2))
			
		--trigrams
	    trigrams = nn.Sequential()
		trigrams:add(nn.TemporalConvolution(50, 100, 3, 1))
		trigrams:add(nn.ReLU())
		trigrams:add(nn.TemporalMaxPooling(2, 2))
		
		--quadgrams
	    quadgrams = nn.Sequential()
		quadgrams:add(nn.TemporalConvolution(50, 100, 4, 1))
		quadgrams:add(nn.ReLU())
		quadgrams:add(nn.TemporalMaxPooling(1, 2))

		par=nn.Concat(2)
		par:add(bigrams)
		par:add(trigrams)
		par:add(quadgrams)

	    model = nn.Sequential()
		model:add(par)
		
		model:add(nn.TemporalConvolution(100, 150, 4, 2))
		model:add(nn.ReLU())
		model:add(nn.TemporalMaxPooling(4, 2))
		
		model:add(nn.TemporalConvolution(150, 170, 3, 3))
		model:add(nn.ReLU())
		model:add(nn.TemporalMaxPooling(3, 1))

		model:add(nn.Reshape(170, true))	
	    model:add(nn.Linear(170, 5))
		model:add(nn.LogSoftMax())
		
	elseif opt.model=='smallerboy_200' then
		
		--bigrams
	    bigrams = nn.Sequential()
		bigrams:add(nn.TemporalConvolution(200, 300, 2, 1))
		bigrams:add(nn.ReLU())
		bigrams:add(nn.TemporalMaxPooling(3, 2))
			
		--trigrams
	    trigrams = nn.Sequential()
		trigrams:add(nn.TemporalConvolution(200, 300, 3, 1))
		trigrams:add(nn.ReLU())
		trigrams:add(nn.TemporalMaxPooling(2, 2))
		
		--quadgrams
	    quadgrams = nn.Sequential()
		quadgrams:add(nn.TemporalConvolution(200, 300, 4, 1))
		quadgrams:add(nn.ReLU())
		quadgrams:add(nn.TemporalMaxPooling(1, 2))

		par=nn.Concat(2)
		par:add(bigrams)
		par:add(trigrams)
		par:add(quadgrams)

	    model = nn.Sequential()
		model:add(par)

		model:add(nn.TemporalConvolution(300, 400, 4, 2))
		model:add(nn.ReLU())
		model:add(nn.TemporalMaxPooling(4, 2))
		
		model:add(nn.TemporalConvolution(400, 400, 3, 3))
		model:add(nn.ReLU())
		model:add(nn.TemporalMaxPooling(3, 1))
		
		model:add(nn.Reshape(400, true))	
	    model:add(nn.Linear(400, 5))
		model:add(nn.LogSoftMax())
		
	else
		error("Invalid model name")
	end
	
	return model, nn.ClassNLLCriterion()

end

return M
