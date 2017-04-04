
class Inventory {
  constructor(inventory) {
    this.items = inventory
  }

  add(item) {
    var exists = this.items.find(i => i.type == item.type)
    if (exists) { exists.q += 1 } else {
      this.items.push(item)
    }
  }

  drop(item) {
    this.items.find(i => i.type == item.type).q -= item.q
    var zeroItem = this.items.find(i => i.q <= 0)
    if (zeroItem) this.items.splice(this.items.indexOf(zeroItem), 1)
  }
}

module.exports = Inventory
