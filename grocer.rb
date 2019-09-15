def consolidate_cart(cart)
  new_cart = {}
  cart.each do |hash| #hash is the whole array
    hash.each do |name, describe| #name: avocado, cheese. describe: price, clearance
      #if new_cart has name and count already, increase the count
      if new_cart[name]
        new_cart[name][:count] += 1
      #new_cart is empty so set name as key and describe as value
      else
        new_cart[name] = describe
        new_cart[name][:count] = 1 #set count = 1 cuz we set name and describe for 1 item
      end
    end
  end
  new_cart
end

def apply_coupons(cart, coupons)
  #doesn't break if there is no coupon
  return cart if coupons == []

  coupons.each do |coupon|
    name = coupon[:item] #avocado, cheese,...
    num_of_c = coupon[:num]

    if cart.include?(name) && cart[name][:count] >= num_of_c
       #remove number of the new_cart's count
       new_cart[name][:count] -= num_of_c

       if new_cart["#{name} W/COUPON"]
         new_cart["#{name} W/COUPON"][:count] += 1
       #set the name with coupon with new value
       else
         new_cart["#{name} W/COUPON"] = {
           :price => coupon[:cost],
           :clearance => new_cart[name][:clearance],
           :count => 1
         }
       end
     end
   end
   new_cart
end


def apply_clearance(cart)
  new_cart = cart
  cart.each do |name, hash|
      if hash[:clearance] #if clearance is true, take 20% off
        new_cart[name][:price] = (cart[name][:price] * 0.8).round(2)
      end
  end
  new_cart #if not, just return the same cart
end


def checkout(cart, coupons)
  #call the consolidate to get the count item first
  new_cart = consolidate_cart(cart)
  #apply coupon to the new cart
  apply_coupons(new_cart, coupons)
  #apply clearance after discount from coupon
  apply_clearance(new_cart)

total = 0
  new_cart.each do |name, hash|
    total += (hash[:price] * hash[:count])
  end

if total >= 100
    total *= 0.9
  end

  total
end