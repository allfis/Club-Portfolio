// ─── CANVAS NETWORK ───
(function () {
  const canvas = document.getElementById("hero-canvas");
  const ctx = canvas.getContext("2d");
  let W,
    H,
    nodes = [],
    animId;
  const NODE_COUNT = 55;
  const MAX_DIST = 160;
  const CAREER_ICONS = ["⚡", "🎯", "💼", "🚀", "📊", "🔬", "⚙️"];

  function resize() {
    W = canvas.width = canvas.offsetWidth;
    H = canvas.height = canvas.offsetHeight;
  }

  function initNodes() {
    nodes = [];
    for (let i = 0; i < NODE_COUNT; i++) {
      nodes.push({
        x: Math.random() * W,
        y: Math.random() * H,
        vx: (Math.random() - 0.5) * 0.35,
        vy: (Math.random() - 0.5) * 0.35,
        r: Math.random() * 2.5 + 1.5,
        pulse: Math.random() * Math.PI * 2,
        type: Math.random() > 0.85 ? "icon" : "dot",
        icon: CAREER_ICONS[Math.floor(Math.random() * CAREER_ICONS.length)],
      });
    }
  }

  function draw() {
    ctx.clearRect(0, 0, W, H);
    const t = Date.now() * 0.001;
    nodes.forEach((n) => {
      n.x += n.vx;
      n.y += n.vy;
      if (n.x < 0 || n.x > W) n.vx *= -1;
      if (n.y < 0 || n.y > H) n.vy *= -1;
      n.pulse += 0.02;
    });
    for (let i = 0; i < nodes.length; i++) {
      for (let j = i + 1; j < nodes.length; j++) {
        const dx = nodes[i].x - nodes[j].x;
        const dy = nodes[i].y - nodes[j].y;
        const dist = Math.sqrt(dx * dx + dy * dy);
        if (dist < MAX_DIST) {
          const alpha = (1 - dist / MAX_DIST) * 0.18;
          ctx.beginPath();
          ctx.moveTo(nodes[i].x, nodes[i].y);
          ctx.lineTo(nodes[j].x, nodes[j].y);
          ctx.strokeStyle = `rgba(26,170,144,${alpha})`;
          ctx.lineWidth = 0.8;
          ctx.stroke();
        }
      }
    }
    nodes.forEach((n) => {
      const pulse = 0.7 + 0.3 * Math.sin(n.pulse);
      if (n.type === "icon") {
        ctx.globalAlpha = 0.15 * pulse;
        ctx.font = `${12}px sans-serif`;
        ctx.fillText(n.icon, n.x - 8, n.y + 4);
        ctx.globalAlpha = 1;
      } else {
        ctx.beginPath();
        ctx.arc(n.x, n.y, n.r * pulse, 0, Math.PI * 2);
        ctx.fillStyle = `rgba(26,170,144,${0.5 * pulse})`;
        ctx.fill();
      }
    });
    animId = requestAnimationFrame(draw);
  }

  resize();
  initNodes();
  draw();
  window.addEventListener("resize", () => {
    resize();
    initNodes();
  });
})();

// ─── NAV SCROLL ───
const nav = document.getElementById("main-nav");
window.addEventListener("scroll", () => {
  nav.classList.toggle("scrolled", window.scrollY > 50);
});

// ─── REVEAL ON SCROLL ───
const reveals = document.querySelectorAll(".reveal");
const observer = new IntersectionObserver(
  (entries) => {
    entries.forEach((e, i) => {
      if (e.isIntersecting) {
        setTimeout(() => {
          e.target.classList.add("in");
          e.target
            .querySelectorAll(".section-title")
            .forEach((t) => t.classList.add("revealed"));
        }, i * 60);
      }
    });
  },
  { threshold: 0.1 },
);
reveals.forEach((el) => observer.observe(el));

// ─── TYPEWRITER ───
(function () {
  const phrases = [
    "Drive Your Profession",
    "Shape Your Future",
    "Build Your Legacy",
    "Lead With Purpose",
  ];
  const el = document.getElementById("typewriter-line");
  let pi = 0,
    ci = 0,
    deleting = false;
  function type() {
    const phrase = phrases[pi];
    if (!deleting) {
      el.textContent = phrase.slice(0, ci + 1);
      ci++;
      if (ci === phrase.length) {
        deleting = true;
        setTimeout(type, 2200);
        return;
      }
    } else {
      el.textContent = phrase.slice(0, ci - 1);
      ci--;
      if (ci === 0) {
        deleting = false;
        pi = (pi + 1) % phrases.length;
      }
    }
    setTimeout(type, deleting ? 50 : 90);
  }
  setTimeout(type, 1800);
})();

// ─── FORM ───
function handleFormSubmit(btn) {
  btn.textContent = "Sending...";
  btn.disabled = true;
  setTimeout(() => {
    btn.textContent = "✓ Message Sent!";
    btn.style.background = "#00e676";
    setTimeout(() => {
      btn.textContent = "Send Message →";
      btn.disabled = false;
      btn.style.background = "";
    }, 3000);
  }, 1200);
}

// ─── CHATBOT ───
let chatOpen = false;
let chatHistory = [];
let isSending = false;

const chatTrigger = document.getElementById("chat-trigger");
const chatWindow = document.getElementById("chat-window");
const chatInput = document.getElementById("chat-input");
const chatSend = document.getElementById("chat-send");
const chatMsgs = document.getElementById("chat-messages");

chatTrigger.addEventListener("click", () => {
  chatOpen = !chatOpen;
  chatWindow.classList.toggle("visible", chatOpen);
  chatTrigger.classList.toggle("open", chatOpen);
  chatTrigger.textContent = chatOpen ? "✕" : "💬";
  if (chatOpen) setTimeout(() => chatInput.focus(), 300);
});

chatInput.addEventListener("keydown", (e) => {
  if (e.key === "Enter" && !e.shiftKey) {
    e.preventDefault();
    sendMessage();
  }
});

function quickAsk(q) {
  chatInput.value = q;
  sendMessage();
}

function appendMsg(role, text) {
  const div = document.createElement("div");
  div.className = `msg ${role}`;
  if (role === "bot") {
    div.innerHTML = `<div class="msg-bot-icon">🤖</div><div class="msg-bubble">${text}</div>`;
  } else {
    div.innerHTML = `<div class="msg-bubble">${text}</div>`;
  }
  chatMsgs.appendChild(div);
  chatMsgs.scrollTop = chatMsgs.scrollHeight;
  return div;
}

function showTyping() {
  const div = document.createElement("div");
  div.className = "msg bot";
  div.id = "typing-indicator";
  div.innerHTML = `<div class="msg-bot-icon">🤖</div><div class="msg-bubble"><div class="typing-dots"><span></span><span></span><span></span></div></div>`;
  chatMsgs.appendChild(div);
  chatMsgs.scrollTop = chatMsgs.scrollHeight;
}
function removeTyping() {
  const t = document.getElementById("typing-indicator");
  if (t) t.remove();
}

async function sendMessage() {
  const text = chatInput.value.trim();
  if (!text || isSending) return;
  chatInput.value = "";
  isSending = true;
  chatSend.disabled = true;
  appendMsg("user", text);
  chatHistory.push({ role: "user", content: text });
  showTyping();

  const systemPrompt = `You are KCC Assistant, the friendly and knowledgeable AI chatbot for KUET Career Club (KCC) at Khulna University of Engineering and Technology, Bangladesh.

Key facts about KCC:
- Full name: KUET Career Club (KCC)
- Tagline: "Let Passion Drive Your Profession"
- Based at KUET, Khulna-9203, Bangladesh
- Contact: kuetcareerclub@gmail.com | +880 1842-222493
- Social: facebook.com/kuetcareerclub | youtube.com/c/KUETCareerClub | LinkedIn: kuetcareerclub
- Website has YouTube channel at youtube.com/c/KUETCareerClub

Programs & Events:
1. BizBash (flagship business case competition, currently at BizBash 5.0, sponsored by Shah Cement)
2. BCS On The Run (BCS preparation seminar featuring recommended BCS cadres from KUET)
3. Study Abroad Sessions (GRE, TOEFL, IELTS guidance, partnerships with DAAD for Germany)
4. Skill Development Workshops (MS Excel, prompt engineering, etc.)
5. KCC Podcast "On The Run" (on Spotify - BCS cadres share their journey)
6. Career Festivals and Seminars
7. MoU with Interactive Cares for student benefits

KCC provides: career seminars, BCS prep, higher study guidance, leadership training, alumni mentorship, career festivals, skill workshops.

How to join KCC: Students at KUET can reach out via email at kuetcareerclub@gmail.com or through the Facebook page, or use the contact form on the website. Membership is open to all KUET students.

Leadership: President is Md. Jubaer Rahman; Vice President is Abdullah al Naeem.

Always be helpful, warm, and concise. Use emojis occasionally. Keep responses under 120 words unless more detail is clearly needed. If asked something you don't know, suggest contacting KCC directly.`;

  try {
    const res = await fetch("https://api.anthropic.com/v1/messages", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        model: "claude-sonnet-4-20250514",
        max_tokens: 1000,
        system: systemPrompt,
        messages: chatHistory,
      }),
    });
    const data = await res.json();
    const reply =
      data.content?.map((b) => b.text || "").join("") ||
      "Sorry, I couldn't get a response. Please try again!";
    removeTyping();
    chatHistory.push({ role: "assistant", content: reply });
    appendMsg("bot", reply.replace(/\n/g, "<br>"));
  } catch {
    removeTyping();
    appendMsg(
      "bot",
      "Oops! Something went wrong. Please try again or contact us at kuetcareerclub@gmail.com 😊",
    );
  }
  isSending = false;
  chatSend.disabled = false;
}

// ─── MOUSE BUBBLE EFFECT ───
(function () {
  const canvas = document.getElementById("mouse-canvas");
  const ctx = canvas.getContext("2d");
  let W, H;
  const bubbles = [];
  const CAREER_WORDS = [
    "Career",
    "BCS",
    "KCC",
    "Growth",
    "Skills",
    "Dream",
    "Future",
    "Job",
    "Learn",
    "Lead",
  ];

  function resize() {
    W = canvas.width = window.innerWidth;
    H = canvas.height = window.innerHeight;
  }

  document.addEventListener("mousemove", function (e) {
    const mx = e.clientX,
      my = e.clientY;
    // spawn 2-3 bubbles per mouse move
    const count = Math.floor(Math.random() * 2) + 1;
    for (let i = 0; i < count; i++) {
      const isWord = Math.random() > 0.82;
      bubbles.push({
        x: mx + (Math.random() - 0.5) * 24,
        y: my + (Math.random() - 0.5) * 24,
        vx: (Math.random() - 0.5) * 1.8,
        vy: -(Math.random() * 2.2 + 0.6),
        r: Math.random() * 10 + 4,
        life: 1,
        decay: Math.random() * 0.022 + 0.012,
        type: isWord ? "word" : "circle",
        word: CAREER_WORDS[Math.floor(Math.random() * CAREER_WORDS.length)],
        fontSize: Math.floor(Math.random() * 8 + 9),
        hue: Math.random() > 0.5 ? "0,212,245" : "245,200,66",
        spin: (Math.random() - 0.5) * 0.06,
      });
    }
  });

  function draw() {
    ctx.clearRect(0, 0, W, H);
    for (let i = bubbles.length - 1; i >= 0; i--) {
      const b = bubbles[i];
      b.x += b.vx;
      b.y += b.vy;
      b.vy += 0.035; // gentle gravity
      b.vx += b.spin;
      b.life -= b.decay;
      b.r *= 0.998;
      if (b.life <= 0) {
        bubbles.splice(i, 1);
        continue;
      }

      const alpha = b.life * 0.65;

      if (b.type === "circle") {
        // outer glow ring
        ctx.beginPath();
        ctx.arc(b.x, b.y, b.r * 1.6, 0, Math.PI * 2);
        ctx.fillStyle = `rgba(${b.hue},${alpha * 0.15})`;
        ctx.fill();
        // inner bubble
        ctx.beginPath();
        ctx.arc(b.x, b.y, b.r, 0, Math.PI * 2);
        ctx.fillStyle = `rgba(${b.hue},${alpha * 0.3})`;
        ctx.fill();
        // bubble stroke
        ctx.beginPath();
        ctx.arc(b.x, b.y, b.r, 0, Math.PI * 2);
        ctx.strokeStyle = `rgba(${b.hue},${alpha * 0.7})`;
        ctx.lineWidth = 1;
        ctx.stroke();
        // highlight
        ctx.beginPath();
        ctx.arc(b.x - b.r * 0.3, b.y - b.r * 0.3, b.r * 0.25, 0, Math.PI * 2);
        ctx.fillStyle = `rgba(255,255,255,${alpha * 0.4})`;
        ctx.fill();
      } else {
        // word bubble
        ctx.save();
        ctx.globalAlpha = alpha * 0.75;
        ctx.font = `600 ${b.fontSize}px 'Syne', sans-serif`;
        ctx.fillStyle = `rgba(${b.hue},1)`;
        ctx.textAlign = "center";
        ctx.fillText(b.word, b.x, b.y);
        ctx.restore();
      }
    }
    requestAnimationFrame(draw);
  }

  resize();
  draw();
  window.addEventListener("resize", resize);
})();
