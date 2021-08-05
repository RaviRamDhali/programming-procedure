

return objCars.filter((value, index, self) => self.map(x => x.Id).indexOf(value.Id) == index)


