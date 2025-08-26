window.addEventListener("message", async (event) => {
    console.log(event.data);
    if (event.data.type == "Init") {
        //maxRetail
        //maxWholesale
        
        // Ensure market tab visibility is set based on config
        if (event.data.enableMarket !== undefined) {
            const marketNavBtn = document.querySelectorAll(".nav__button")[2]; // Market is the third button (index 2)
            if (!event.data.enableMarket) {
                marketNavBtn.style.display = "none";
            } else {
                marketNavBtn.style.display = ""; // Reset to default display
            }
        }
    }
    else if (event.data.type == "Open") {
        ChangePage(event.data.pageNumber);
        ShowHide(true);
        //event.data.level int
        //event.data.xp int
        //event.data.nextxp int
        //event.data.items array
        //event.data.coords array
    }
    else if (event.data.type == "Close") {
        ShowHide(false);
        SendNUI("CloseUI");
    }
});

window.addEventListener("keydown", (e) => {
    if (e.key === "Escape") {
        ShowHide(false);
        SendNUI("CloseUI");
    }
});