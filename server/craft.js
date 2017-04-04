module.exports = {
  formulas: [
    {
      id: 1,
      items: [ { type: 1, q: 3 } ],
      item: { type: 2, q: 1 },
      chance: 70
    },
    {
      id: 2,
      items: [ { type: 2, q: 1 } ],
      app: { type: 1 },
      chance: 70
    }
  ],
  canCraft: function(formula, user) {
    var canCraft = true
    formula.items.forEach(i => {
      var myItem = user.inventory.items.find(ii => ii.type == i.type)
      if (!myItem || myItem.q < i.q) {
        canCraft = false
      }
    })
    return canCraft
  }
}
