import { Controller } from "@hotwired/stimulus"

// Klondike, draw one. Cards are dragged between piles; a double-click sends a
// card up to the foundations. Every render redraws the piles from this.piles.

const SUITS = ["♠", "♥", "♦", "♣"]
const RANKS = ["", "A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
const FOUNDATIONS = ["foundation-0", "foundation-1", "foundation-2", "foundation-3"]

export default class extends Controller {
  static targets = ["pile", "message"]

  connect() {
    this.newGame()
  }

  newGame() {
    const deck = SUITS.flatMap(suit => RANKS.slice(1).map((_, i) => ({ suit, rank: i + 1, up: false })))
    for (let i = deck.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1))
      ;[deck[i], deck[j]] = [deck[j], deck[i]]
    }

    this.piles = { waste: [] }
    FOUNDATIONS.forEach(name => this.piles[name] = [])
    for (let i = 0; i < 7; i++) {
      const cards = deck.splice(0, i + 1)
      cards.at(-1).up = true
      this.piles[`tableau-${i}`] = cards
    }
    this.piles.stock = deck
    this.render()
  }

  draw() {
    const { stock, waste } = this.piles
    if (stock.length) {
      const card = stock.pop()
      card.up = true
      waste.push(card)
    } else {
      this.piles.stock = waste.reverse().map(card => ({ ...card, up: false }))
      this.piles.waste = []
    }
    this.render()
  }

  // Drag and drop

  grab(event) {
    const el = event.target.closest(".card")
    if (!el || event.button !== 0) return

    const { pile, index } = this.cardInfo(el)
    const cards = this.piles[pile]
    if (pile === "stock" || !cards[index].up) return
    if (!pile.startsWith("tableau") && index !== cards.length - 1) return

    const els = [...this.element.querySelectorAll(`.card[data-pile="${pile}"]`)]
      .filter(card => Number(card.dataset.index) >= index)
    this.dragging = { pile, index, els, x: event.clientX, y: event.clientY, moved: false }
  }

  drag(event) {
    const d = this.dragging
    if (!d) return

    const dx = event.clientX - d.x
    const dy = event.clientY - d.y
    if (!d.moved && Math.hypot(dx, dy) < 4) return

    d.moved = true
    d.els.forEach(el => {
      el.classList.add("dragging")
      el.style.transform = `translate(${dx}px, ${dy}px)`
    })
  }

  drop() {
    const d = this.dragging
    if (!d) return
    this.dragging = null
    if (!d.moved) return

    const cards = this.piles[d.pile].slice(d.index)
    const target = this.overlappingPiles(d.els[0])
      .find(name => name !== d.pile && this.canPlace(cards, name))

    if (target) this.move(d.pile, d.index, target)
    else this.render()
  }

  // Double-clicking a card sends it to the foundations
  autoMove(event) {
    const el = event.target.closest(".card")
    if (!el) return

    const { pile, index } = this.cardInfo(el)
    const cards = this.piles[pile]
    if (pile === "stock" || index !== cards.length - 1 || !cards[index].up) return

    const target = FOUNDATIONS.find(name => this.canPlace([cards[index]], name))
    if (target) this.move(pile, index, target)
  }

  // Rules

  canPlace(cards, name) {
    const card = cards[0]
    const top = this.piles[name].at(-1)

    if (name.startsWith("foundation")) {
      if (cards.length !== 1) return false
      return top ? top.suit === card.suit && card.rank === top.rank + 1 : card.rank === 1
    }
    if (name.startsWith("tableau")) {
      return top ? top.up && this.isRed(top) !== this.isRed(card) && card.rank === top.rank - 1 : card.rank === 13
    }
    return false
  }

  move(from, index, to) {
    this.piles[to].push(...this.piles[from].splice(index))
    const exposed = this.piles[from].at(-1)
    if (exposed) exposed.up = true
    this.render()
  }

  // Helpers

  isRed(card) {
    return card.suit === "♥" || card.suit === "♦"
  }

  cardInfo(el) {
    return { pile: el.dataset.pile, index: Number(el.dataset.index) }
  }

  overlappingPiles(el) {
    const a = el.getBoundingClientRect()
    return this.pileTargets
      .map(pile => {
        const b = pile.getBoundingClientRect()
        const w = Math.min(a.right, b.right) - Math.max(a.left, b.left)
        const h = Math.min(a.bottom, b.bottom) - Math.max(a.top, b.top)
        return { name: pile.dataset.pile, area: w > 0 && h > 0 ? w * h : 0 }
      })
      .filter(p => p.area > 0)
      .sort((p, q) => q.area - p.area)
      .map(p => p.name)
  }

  // Rendering

  render() {
    this.pileTargets.forEach(el => {
      const name = el.dataset.pile
      const cards = this.piles[name].map((card, index) => [card, index])
      // Stacked piles only need the top two cards (one to drag, one to show beneath).
      const shown = name.startsWith("tableau") ? cards : cards.slice(-2)
      el.innerHTML = shown.map(([card, index]) => this.cardHTML(card, name, index)).join("")
    })

    const won = FOUNDATIONS.every(name => this.piles[name].length === 13)
    this.messageTarget.textContent = won ? "You win! 🎉" : ""
  }

  cardHTML(card, pile, index) {
    const data = `data-pile="${pile}" data-index="${index}"`
    if (!card.up) return `<div class="card down" ${data}></div>`

    const color = this.isRed(card) ? "red" : ""
    return `<div class="card ${color}" ${data}>${RANKS[card.rank]}${card.suit}<span class="big">${card.suit}</span></div>`
  }
}
