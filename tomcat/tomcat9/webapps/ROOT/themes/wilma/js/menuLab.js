const programSelect = document.getElementById("programList");
console.log(programSelect);
const cardXProgram = document.querySelectorAll("#IDCard li") 
console.log(cardXProgram);

programSelect.addEventListener("change", ()=>{
    const selectedprogramSelect = programSelect.value;

    cardXProgram.forEach(cardXProgram => {
        const categoriacardXProgram = cardXProgram.getAttribute("data-category");

        if( selectedprogramSelect=== "todos" || categoriacardXProgram === selectedprogramSelect ){
            cardXProgram.style.display = "block"; 
        } else{
            cardXProgram.style.display = "none";
        }
    })
})