ctx.OrderCartItems
    .Where(a => a.cartID == cartID && a.productPrice == 0)
    .ToList()
    .ForEach(m => ctx.OrderCartItems.Remove(m));

ctx.SaveChanges();
