import { Controller } from "@hotwired/stimulus";
export default class extends Controller {
  connect() {
    // Use an arrow function to preserve `this` context
    addEventListener("trix-initialize", (event) => {
      const trixEditor = event.target;
      const aiButtonCheckSpell = document.createElement("button");

      aiButtonCheckSpell.setAttribute("type", "button");
      aiButtonCheckSpell.setAttribute("tabindex", -1);
      aiButtonCheckSpell.setAttribute("title", "Check Spelling");
      aiButtonCheckSpell.classList.add("trix-button");
      aiButtonCheckSpell.innerHTML = `
          <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24">
            <!-- Main check icon -->
            <path fill="#4CAF50" d="M21 7L9 19l-5.5-5.5 1.41-1.41L9 16.17 19.59 5.59 21 7z"/>
            <path fill="#BBDEFB" d="M14 3v5h5M12 18v-2h6v2h-6zm0-4v-2h4v2h-4z"/>
            <g transform="translate(18 2)">
              <rect width="16" height="8" x="-16" y="0" fill="#FF9800" rx="1.5"/>
              <text x="-8" y="4.5" font-size="6" font-family="Arial" fill="white" text-anchor="middle" dominant-baseline="middle">AI</text>
            </g>
          </svg>
      `;


      // Append the button to the toolbar
      document.querySelector(".trix-button-group--text-tools").appendChild(aiButtonCheckSpell);

      const aiButtonCalculateExpresions = document.createElement("button");
      aiButtonCalculateExpresions.setAttribute("type", "button");
      aiButtonCalculateExpresions.setAttribute("tabindex", -1);
      aiButtonCalculateExpresions.setAttribute("title", "Calculate Expressions");
      aiButtonCalculateExpresions.classList.add("trix-button");
      aiButtonCalculateExpresions.innerHTML = `
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="24" height="24">
                      <rect x="2" y="4" width="20" height="14" fill="#F5F5F5" stroke="#CCCCCC" stroke-width="1" rx="2" ry="2" />
                      <line x1="8" y1="11" x2="16" y2="11" stroke="#3498DB" stroke-width="2" />
                      <line x1="12" y1="7" x2="12" y2="15" stroke="#3498DB" stroke-width="2" />
                    </svg>
      `;

      // Append the button to the toolbar
      document.querySelector(".trix-button-group--text-tools").appendChild(aiButtonCalculateExpresions);

      // Attach the click event to the button
      aiButtonCheckSpell.addEventListener("click", () => {
        this.correctOrthography(trixEditor);
      });

      aiButtonCalculateExpresions.addEventListener("click", () => {
        this.calculateExpression(trixEditor);
      });
       
    });
  }

  async correctOrthography(trixEditor) {
    try {
      const editor = trixEditor.editor;
      const content = editor.getDocument().toString(); // Get the current content

      // Send the content to the backend for correction
      const response = await fetch("/trix_genius/correct_spelling", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ text: content }),
      });

      if (!response.ok) {
        throw new Error("Network response was not ok");
      }
      const result = await response.json();

      editor.loadHTML(result.corrected_text);
    } catch (error) {
      console.error("Error correcting orthography:", error);
      alert("An error occurred while correcting orthography.");
    }
  }


   async calculateExpression(trixEditor) {
    try {
      const editor = trixEditor.editor;
      const content = editor.getDocument().toString(); // Get the current content

      // Send the content to the backend for correction
      const response = await fetch("/trix_genius/calculate_expression", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ text: content }),
      });

      if (!response.ok) {
        throw new Error("Network response was not ok");
      }

      const result = await response.json();
      editor.loadHTML(result.calculus.replace(/\n/g, "<br>"));

    } catch (error) {
      console.error("Error Calculate Expressions:", error);
      alert("An error occurred while calculate expression.");
    }
  }   
}

