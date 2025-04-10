import { Controller } from "@hotwired/stimulus";
export default class extends Controller {
  connect() {
    // Use an arrow function to preserve `this` context
    addEventListener("trix-initialize", (event) => {
      const trixEditor = event.target;

      // Create the AI button
      const aiButton = document.createElement("button");
      aiButton.setAttribute("type", "button");
      aiButton.setAttribute("tabindex", -1);
      aiButton.setAttribute("title", "Correct Orthography");
      aiButton.classList.add("trix-button"); // Use Trix's default button styling
      aiButton.innerHTML = `
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="16" height="16" fill="currentColor">
          <path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/>
        </svg>
      `;

      // Append the button to the toolbar
      document.querySelector(".trix-button-group--text-tools").appendChild(aiButton);

      // Attach the click event to the button
      aiButton.addEventListener("click", () => {
        this.correctOrthography(trixEditor);
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
}
