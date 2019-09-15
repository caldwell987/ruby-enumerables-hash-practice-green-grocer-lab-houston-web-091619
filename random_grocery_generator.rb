require_relative 'grocer'

def generateCart
	cart = []
	rand(20).times do
		cart.push(ITEMS.sample)  
	end
	cart
end

#randomly generates set of coupons
def generateCoups
	coups = []
	rand(2).times do
		coups.push(COUPS.sample)
end
 coups
end



