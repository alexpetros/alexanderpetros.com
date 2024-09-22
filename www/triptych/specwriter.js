// Create <section-ref> element
class SectionRef extends HTMLElement {
  connectedCallback() {
    const content = this.innerHTML
    const ref = this.attributes.ref.value
    this.innerHTML = `<a href="#${ref}">${content}</a>`
  }
}
customElements.define('section-ref', SectionRef)

// Create <f-note> element
class Footnote extends HTMLElement {
  static numFootnotes = 0

  connectedCallback() {
    Footnote.numFootnotes += 1

    this.content = this.innerHTML
    this.num = Footnote.numFootnotes
    this.innerHTML = `<sup id="fn-${this.num}"><a href="#ref-${this.num}">[${this.num}]</a></sup>`
  }

}
customElements.define('f-note', Footnote)

class FootnoteList extends HTMLElement {
  connectedCallback() {
    // const template = document.createElement('template')
    const footnotes = document.querySelectorAll('f-note')
    for (const footnote of footnotes) {
      const p = document.createElement('p')
      p.classList.add('footnote')
      p.id = `ref-${footnote.num}`
      p.innerHTML = `[${footnote.num}] ${footnote.content} <a href="#fn-${footnote.num}">↩</a>`
      this.append(p)
    }
  }
}
customElements.define('footnote-list', FootnoteList)

class TableOfContents extends HTMLElement {
   connectedCallback() {
    // Create table of contents
    const headings = document.querySelectorAll('h2,h3')
    const topList = document.createElement('ol')
    let currentH2
    for (const heading of headings) {
      // Create an id if one doesn't exist
      heading.id = heading.id || heading.innerText.replace(' ', '-')
      if (heading.tagName === 'H2') {
        currentH2 = document.createElement('li')
        currentH2.innerHTML = `<a href="#${heading.id}">${heading.innerText}</a><ol></ol>`
        topList.append(currentH2)
      } else {
        const h2Sublist = currentH2.querySelector('ol')
        const h3Item = document.createElement('li')
        h3Item.innerHTML = `<a href="#${heading.id}">${heading.innerText}</a><ol></ol>`
        h2Sublist.append(h3Item)
      }
    }
    this.append(topList)
  }
}
customElements.define('table-of-contents', TableOfContents)
