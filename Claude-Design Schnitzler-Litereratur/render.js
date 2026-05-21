// Render the index — flowing list of entries, no separators, [D##] on the right.
(function () {
  const entries = window.ENTRIES || [];
  const index = document.getElementById('index');
  const alpha = document.getElementById('alpha');
  const countEl = document.getElementById('entry-count');

  // ---------- helpers ----------
  function firstLetter(note) {
    if (!note) return '#';
    const cleaned = note.replace(/~~[^~]*~~/g, '').replace(/^[\W_]+/, '').trim();
    const c = (cleaned[0] || '#').toUpperCase();
    const map = { 'Ä': 'A', 'Ö': 'O', 'Ü': 'U', 'ß': 'S' };
    return map[c] || c;
  }

  function escapeHtml(s) {
    return s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
  }

  // Detect typewritten vs handwritten passages.
  // Convention: runs of 2+ hyphens "--", "---", "----" are typewriter long-dashes.
  // Handwritten entries use en-dash "–", ellipses "..", "...", or no dash at all.
  function isTypewritten(note) {
    if (!note) return false;
    return /-{2,}/.test(note);
  }

  function renderNote(note) {
    if (!note) return '';
    let s = escapeHtml(note);
    // Strikethrough
    s = s.replace(/~~([^~]+)~~/g, '<s>$1</s>');
    return s;
  }

  // ---------- group by letter (for anchors only) ----------
  const groups = {};
  const letterOrder = [];
  for (const e of entries) {
    const L = firstLetter(e.note);
    if (!groups[L]) { groups[L] = []; letterOrder.push(L); }
    groups[L].push(e);
  }
  letterOrder.sort();

  // ---------- render rows ----------
  const frag = document.createDocumentFragment();
  let lastLetter = null;
  for (const e of entries) {
    const L = firstLetter(e.note);
    if (L !== lastLetter) {
      const anchor = document.createElement('span');
      anchor.className = 'letter-anchor';
      anchor.id = 'letter-' + L;
      frag.appendChild(anchor);
      lastLetter = L;
    }

    const row = document.createElement('div');
    row.className = 'row';
    if (e.meta) row.classList.add('has-meta');

    const note = document.createElement('div');
    note.className = 'note ' + (isTypewritten(e.note) ? 'typewritten' : 'handwritten');
    note.innerHTML = renderNote(e.note);

    const authors = document.createElement('div');
    authors.className = 'authors';
    if (e.authors.length === 0) {
      const span = document.createElement('span');
      span.className = 'no-authors';
      span.textContent = e.meta ? '— ' + e.meta : '— ohne Zuordnung';
      authors.appendChild(span);
    } else {
      for (const a of e.authors) {
        const link = document.createElement('a');
        link.href = a.url;
        link.target = '_blank';
        link.rel = 'noopener';
        link.innerHTML = `<span class="arrow">→</span>${escapeHtml(a.name)}`;
        authors.appendChild(link);
      }
      if (e.meta) {
        const m = document.createElement('div');
        const isUnident = /nicht ermittelt/i.test(e.meta);
        m.className = 'meta-tag' + (isUnident ? ' unident' : '');
        m.textContent = '※ ' + e.meta;
        authors.appendChild(m);
      }
    }

    const tag = document.createElement('div');
    tag.className = 'tag';
    tag.textContent = '[' + e.id + ']';

    row.appendChild(note);
    row.appendChild(authors);
    row.appendChild(tag);
    frag.appendChild(row);
  }
  index.appendChild(frag);

  // ---------- alphabet jump bar ----------
  const A = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');
  const have = new Set(letterOrder);
  for (const L of A) {
    const a = document.createElement('a');
    a.textContent = L;
    if (have.has(L)) {
      a.href = '#letter-' + L;
    } else {
      a.className = 'empty';
    }
    alpha.appendChild(a);
  }

  // ---------- entry count ----------
  if (countEl) countEl.textContent = entries.length;

  // ---------- back to top ----------
  const totop = document.getElementById('totop');
  window.addEventListener('scroll', () => {
    if (window.scrollY > 600) totop.classList.add('show');
    else totop.classList.remove('show');
  }, { passive: true });
  totop.addEventListener('click', () => window.scrollTo({ top: 0, behavior: 'smooth' }));
})();
