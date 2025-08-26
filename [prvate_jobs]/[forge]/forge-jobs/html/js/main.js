const root = document.documentElement;
const pageNumber = 5;
const instructions = document.querySelectorAll(".instruction");
let tools = document.querySelectorAll(".tool");
let missions = document.querySelectorAll(".mission");

let wholesaleLimit = 1500;
let retailLimit = 5;

var currentType = -1;
var currentJob = "";

var toolsObject = [];
var pricesObject = [];

var missionsObject = [];
var enableSellShop = true; // Default value for market visibility

const instructionTexts = [
  [
    "Go to the <span>gathering points</span> in the areas marked on the map and mine as many rocks as you want.",
    "Then you'll need to <span>wash those stones</span> in the washing area to better reveal the minerals hidden inside.",
    "Once your stones are washed, take them to the <span>machine to transform</span> and sell them.",
  ],
  [
    "Go to the <span>hunting spots</span> and kill the prey to then collect all the items they can give you!",
    "Take your raw meat to the <span>slaughterhouse's chemical wash</span> to make it safe for human consumption.",
    "When everything's clean and ready, bring the meat to the <span>final processor</span> and complete your job!",
  ],
  [
    "Stand near any body of water and use your <span>fishing rod</span> to catch fish—patience is key!",
    "Once you've got some fish, bring them to the table to <span>gut and clean out the bones</span> properly.",
    "Then take the clean meat to the <span>processing machine</span> to get your final product.",
  ],
  [
    "Go to the <span>choppable forest</span> and, with your tool, chop down as much wood as you can!",
    "Bring the logs to the <span>saw machine</span> to cut them into planks.",
    "Then go to the <span>shredder machine</span> to turn your planks into wood chips for processing.",
  ],
  [
    "Head to the harvest area and <span>gather as many vegetables</span> as possible.",
    "Then bring your crops to the <span>cutting table</span> to remove leaves and prep them for packaging.",
    "Finally, turn your cleaned produce into <span>preserved goods</span> ready to hit the market.",
  ],
  [
    "You can either <span>dig through trash containers</span> across the map or <span>dismantle old cars</span> at the scrapyard to collect valuable junk.",
    "Take your metal parts to a <span>demagnetizer station</span> to safely remove electronics and other sensitive components.",
    "Then bring the purified scrap to the <span>recycling processor</span> to convert it into high-value material.",
  ],
];

const missionNames = [
  [
    "Mine <span>10 stones</span>",
    "Mine <span>35 stones</span>",
    "Wash <span>10 stones</span>",
  ],
  [
    "Hunt <span>10 pieces</span>",
    "Hunt <span>35 pieces</span>",
    "Hunt <span>10 pieces</span>",
  ],
  [
    "Fish <span>10 fish</span>",
    "Fish <span>35 fish</span>",
    "Fish <span>10 fish</span>",
  ],
  [
    "Chop <span>10 logs</span>",
    "Chop <span>35 logs</span>",
    "Chop <span>10 logs</span>",
  ],
  [
    "Pick <span>10 vegetables</span>",
    "Pick <span>35 vegetables</span>",
    "Pick <span>10 vegetables</span>",
  ],
  [
    "Search <span>10 trashes</span>",
    "Search <span>35 trashes</span>",
    "Search <span>10 trashes</span>",
  ],
];
//WILLY
const unselectMarketItem = () => {
  // WILLY: Remove active class from the selected item
  if(selectedProduct) {
    selectedProduct.classList.remove("active");
  }
  
  // WILLY: Clear selection text
  marketItemName.textContent = "";
  
// WILLY: Reset prices
  wholesaleCircle.textContent = "0";
  retailCircle.textContent = "0";
  
// WILLY: Reset quantities
  wholesaleQuantityBox.textContent = "0";
  retailQuantityBox.textContent = "0";
  
// WILLY: Reset selected item
  selectedProduct = null;
};

// WILLY: Add CSS to visually indicate when an item cannot be sold
const updateWholesaleButton = (available, required) => {
  if (available < required) {
    wholesaleBtn.classList.add("disabled");
  } else {
    wholesaleBtn.classList.remove("disabled");
  }
};

let currencySymbol = "$"; // Default symbol, will be updated from Lua

window.addEventListener("message", async (event) => {
    console.log(event.data);
    if (event.data.type == "Init") {
        Init(event.data.maxRetail, event.data.maxWholesale, event.data.prices, event.data.tools, event.data.characterName, event.data.enableMarket)
    }
    else if (event.data.type == "Open") {
      unselectMarketItem();

        // Store the currency symbol received from Lua
        currencySymbol = event.data.currencySymbol || "$"; 
        
        // Update Market tab visibility when UI opens
        enableSellShop = event.data.enableMarket;
        const marketNavBtn = document.querySelectorAll(".nav__button")[2]; // Market is the third button (index 2)
        if (!enableSellShop) {
            marketNavBtn.style.display = "none";
            
            // If market tab is currently active, switch to Home tab
            if (marketNavBtn.classList.contains("active")) {
                navBtns[0].click(); // Click the Home tab
            }
        } else {
            marketNavBtn.style.display = ""; // Reset to default display
        }

        ChangePage(event.data.pageNumber);
        SetupTools(event.data.pageNumber);
        SetupItems(event.data.items)
        setUserLevel(event.data.level);
        setCurrentXp(event.data.currentXp);
        setRequiredXp(event.data.requiredXp);
        SetMissions();
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
    else if(event.data.type == "UpdateXp"){
        setUserLevel(event.data.level);
        setCurrentXp(event.data.currentXp);
        setRequiredXp(event.data.requiredXp);
    }
    else if(event.data.type == "GetNewMissions"){
        GetNewMissions(event.data.missions, event.data.refreshDate);
    }
    else if(event.data.type == "UpdateMissionProgress"){
        UpdateMissionProgress(event.data.jobName, event.data.mission, event.data.progress);
    }
});

// WILLY
window.addEventListener("keydown", (e) => {
  if (e.key === "Escape") {
      ShowHide(false);
      unselectMarketItem(); // WILLY: Call when ESC is pressed
      SendNUI("CloseUI");
  }
});


function Init(maxRetail, maxWholesale, prices, toolsObj, characterName, enableMarket) {
    setWholesaleRetailLimits(maxWholesale, maxRetail);
    SetupMarkersListeners();
    pricesObject = prices;
    toolsObject = toolsObj;
    enableSellShop = enableMarket; // Store the market visibility setting
    
    // Hide or show the Market tab based on config
    const marketNavBtn = document.querySelectorAll(".nav__button")[2]; // Market is the third button (index 2)
    if (!enableSellShop) {
        marketNavBtn.style.display = "none";
    } else {
        marketNavBtn.style.display = ""; // Reset to default display
    }
    
    //console.log(characterName);
    document.getElementById("firstName").innerHTML = characterName[0];
    document.getElementById("lastName").innerHTML = characterName[1];
}

function SetupMarkersListeners() {
    var buttons = Array.from(document.getElementsByClassName("instruction__button"));
    for (let index = 0; index < buttons.length; index++) {
        const element = buttons[index];
        element.addEventListener("click", () => {
            //console.log("SetMarkerClick");
            SendNUI("SetMarker", JSON.stringify({type: currentType, index: index+1}));
        });
    }
}

// WILLY
function SetupItems(items){
  RemoveAllItemsFromMarket();
  
  for (let index = 0; index < items.length; index++) {
      const element = items[index];
      // MODIFIED: Construct image path dynamically, defaulting to product.png
      const imagePath = element.image ? `assets/images/${element.image}` : 'assets/images/product.png';
      addMarketItem(
          imagePath, // Use the constructed path
          element.name, 
          element.label, 
          pricesObject[element.name].priceWholesale, 
          pricesObject[element.name].priceRetail,     
          element.amount
      )
  }
}

function SetupTools(number){
    RemoveAllTools();

    number--;
    //console.log(number);
    //console.log(toolsObject[number]);
    for (let index = 0; index < toolsObject[number].length; index++) {
        const element = toolsObject[number][index];
        //console.log(element);
        addTool(`assets/images/tools/${element.image}`, element.level, element.item, element.label, element.price);
    }
}

function GetNewMissions(missions, refreshDate){
    missionsObject = missions;
    StartTimer(new Date(refreshDate).getTime() - new Date().getTime() / 1000);
    SetMissions();
}

function UpdateMissionProgress(jobName, missionName, progress){
    missionsObject.forEach(element => {
        if(element.job_name == jobName && element.mission == missionName){
            var oldProgress = element.progress;
            element.progress += progress;
            document.querySelectorAll(".mission").forEach((mission) => { 
                if(mission.dataset.name == element.mission){
                    mission.getElementsByClassName("mission__count")[0].innerHTML.replace(oldProgress, element.progress);
                    if(element.progress >= element.completion) mission.classList.remove("disabled");
                }
            });
        }
    });
}

function SetMissions(){
    removeAllMissions();
    for (let index = 0; index < missionsObject.length; index++) {
        const mission = missionsObject[index];
        if(mission.job_name != currentJob || mission.claimed == 1) continue;
        addMission(mission.mission, mission.label, mission.completion, mission.prize, mission.progress, mission.completion, mission.progress < mission.completion);
    }
}

// Translation
function updateContent() {
  document.querySelectorAll("[data-i18n]").forEach((element) => {
    const key = element.getAttribute("data-i18n");
    element.innerHTML = i18next.t(key);
  });
}

i18next.use(i18nextBrowserLanguageDetector).init(
  {
    resources: {
      en: {
        translation: {
          navBtn1: "home",
          navBtn2: "tool",
          navBtn3: "market",
          navBtn4: "missions",
          toolsTitle: "buy your tool",
          marketTitle: "sell the goods",
          missionsTitle: "some missions",
          instructionBtn: "Mark on the map",
          toolBtn: "buy",
          missionBtn: "claim",
          marketItemName: "You have selected",
          challengeText: `time for the<br /><span>next challenge:</span>`,
        },
      },
      de: {
        translation: {
          navBtn1: "heim",
          navBtn2: "werkzeug",
          navBtn3: "markt",
          navBtn4: "missionen",
          toolsTitle: "kaufen sie ihr werkzeug",
          marketTitle: "die ware verkaufen",
          missionsTitle: "einige missionen",
          instructionBtn: "auf der karte markieren",
          toolBtn: "kaufen",
          missionBtn: "beanspruchen",
          marketItemName: "Sie haben ausgewählt",
          challengeText: `Zeit für die nächste <br /><span>Herausforderung</span>`,
        },
      },
    },
    fallbackLng: "en",
    debug: true,
  },
  (err, t) => {
    if (err) return console.error(err);

    updateContent();
  }
);

// Change language for text
function changeLanguage(lang) {
  i18next.changeLanguage(lang, () => {
    document.querySelectorAll("[data-i18n]").forEach((element) => {
      const key = element.getAttribute("data-i18n");
      element.innerHTML = i18next.t(key);
    });
  });
}

function ChangePage(number) { // WILLY
  currentType = number;
  switch (number) {
      case 1: {
          currentJob = "Mining";
          root.style.setProperty("--primary-color", "#FF0451");
          instructions.forEach((instruction, i) => {
              instruction.querySelector(".instruction__text").innerHTML = instructionTexts[0][i];
              instruction.querySelector(".instruction__bottom-bg img").src = 
                  `assets/images/instructions/${number}-${i + 1}.png`;
          });
          tools.forEach((tool) => {
              tool.querySelector(".tool__name").textContent = "PICKAXE";
              tool.querySelector(".tool__image").src = "assets/images/tools/1.png";
          });
          missions.forEach((mission, i) => {
              mission.querySelector(".mission__name").innerHTML = missionNames[0][i];
          });
          i18next.addResource("en", "translation", "headingName", "mining");
          i18next.addResource("de", "translation", "headingName", "bergbau");
          updateContent();
          break;
      }
      case 2: {
          currentJob = "Hunting";
          root.style.setProperty("--primary-color", "#FF6D04");
          instructions.forEach((instruction, i) => {
              instruction.querySelector(".instruction__text").innerHTML = instructionTexts[1][i];
              instruction.querySelector(".instruction__bottom-bg img").src = 
                  `assets/images/instructions/${number}-${i + 1}.png`;
          });
          tools.forEach((tool) => {
              tool.querySelector(".tool__name").textContent = "RIFLE";
              tool.querySelector(".tool__image").src = "assets/images/tools/2.png";
          });
          missions.forEach((mission, i) => {
              mission.querySelector(".mission__name").innerHTML = missionNames[1][i];
          });
          i18next.addResource("en", "translation", "headingName", "hunting");
          i18next.addResource("de", "translation", "headingName", "jagd");
          updateContent();
          break;
      }
      case 3: {
          currentJob = "Fishing";
          root.style.setProperty("--primary-color", "#04ABFF");
          instructions.forEach((instruction, i) => {
              instruction.querySelector(".instruction__text").innerHTML = instructionTexts[2][i];
              instruction.querySelector(".instruction__bottom-bg img").src = 
                  `assets/images/instructions/${number}-${i + 1}.png`;
          });
          tools.forEach((tool) => {
              tool.querySelector(".tool__name").textContent = "FISHING ROD";
              tool.querySelector(".tool__image").src = "assets/images/tools/3.png";
          });
          missions.forEach((mission, i) => {
              mission.querySelector(".mission__name").innerHTML = missionNames[2][i];
          });
          i18next.addResource("en", "translation", "headingName", "fishing");
          i18next.addResource("de", "translation", "headingName", "angeln");
          updateContent();
          break;
      }
      case 4: {
          currentJob = "Lumberjack";
          root.style.setProperty("--primary-color", "#8F3200");
          instructions.forEach((instruction, i) => {
              instruction.querySelector(".instruction__text").innerHTML = instructionTexts[3][i];
              instruction.querySelector(".instruction__bottom-bg img").src = 
                  `assets/images/instructions/${number}-${i + 1}.png`;
          });
          tools.forEach((tool) => {
              tool.querySelector(".tool__name").textContent = "AXE";
              tool.querySelector(".tool__image").src = "assets/images/tools/4.png";
          });
          missions.forEach((mission, i) => {
              mission.querySelector(".mission__name").innerHTML = missionNames[3][i];
          });
          i18next.addResource("en", "translation", "headingName", "lumberjack");
          i18next.addResource("de", "translation", "headingName", "holzfäller");
          updateContent();
          break;
      }
      case 5: {
          currentJob = "Farming";
          root.style.setProperty("--primary-color", "#5CFF4E");
          instructions.forEach((instruction, i) => {
              instruction.querySelector(".instruction__text").innerHTML = instructionTexts[4][i];
              instruction.querySelector(".instruction__bottom-bg img").src = 
                  `assets/images/instructions/${number}-${i + 1}.png`;
          });
          tools.forEach((tool) => {
              tool.querySelector(".tool__name").textContent = "TROWEL";
              tool.querySelector(".tool__image").src = "assets/images/tools/1.png";
          });
          missions.forEach((mission, i) => {
              mission.querySelector(".mission__name").innerHTML = missionNames[4][i];
          });
          i18next.addResource("en", "translation", "headingName", "farming");
          i18next.addResource("de", "translation", "headingName", "land");
          updateContent();
          break;
      }
      case 6: {
          currentJob = "Recycling";
          root.style.setProperty("--primary-color", "#A9A9A9");
          instructions.forEach((instruction, i) => {
              instruction.querySelector(".instruction__text").innerHTML = instructionTexts[5][i];
              instruction.querySelector(".instruction__bottom-bg img").src = 
                  `assets/images/instructions/${number}-${i + 1}.png`;
          });
          tools.forEach((tool) => {
              tool.querySelector(".tool__name").textContent = "RECYCLER";
              tool.querySelector(".tool__image").src = "assets/images/tools/1.png";
          });
          missions.forEach((mission, i) => {
              mission.querySelector(".mission__name").innerHTML = missionNames[5][i];
          });
          i18next.addResource("en", "translation", "headingName", "recycling");
          i18next.addResource("de", "translation", "headingName", "recycling");
          updateContent();
          break;
      }
  }
}

const forgeJobs = document.querySelector(".forge-jobs");

// Close UI button click
const closeBtn = document.querySelector(".nav__close");

// WILLY
closeBtn.addEventListener("click", () => {
  forgeJobs.classList.remove("active");
  unselectMarketItem(); // WILLY: Call when manually closed
  SendNUI("CloseUI");
});

// Instruction buttons click
const instructionBtns = document.querySelectorAll(".instruction__button");

instructionBtns.forEach((btn) => {
  btn.addEventListener("click", () => {
    forgeJobs.classList.remove("active");
  });
});

// Navigation buttons click
const navBtns = document.querySelectorAll(".nav__button");
const menuBlocks = document.querySelectorAll(".menu__block");

navBtns.forEach((btn, i) => {
  btn.addEventListener("click", () => {
    navBtns.forEach((btn) => btn.classList.remove("active"));
    menuBlocks.forEach((block) => block.classList.remove("active"));

    btn.classList.add("active");
    menuBlocks[i].classList.add("active");
  });
});

// Tool buttons click
const toolBtns = document.querySelectorAll(".tool__button");

toolBtns.forEach((btn) => {
  const popup = btn.closest(".tool").querySelector(".popup");
  const yesBtn = popup.querySelector("button:first-child");
  const noBtn = popup.querySelector("button:last-child");

  btn.addEventListener("click", () => {
    popup.classList.add("active");
  });

  yesBtn.addEventListener("click", () => {
    popup.classList.remove("active");
  });

  noBtn.addEventListener("click", () => {
    popup.classList.remove("active");
  });
});

// Market Items click
let marketItems = document.querySelectorAll(".market__item");
const marketItemName = document.querySelector("#marketItem-name");
const marketPopup = document.querySelector(".market .popup");
const marketPopupYesBtn = marketPopup.querySelector("button:first-child");
const marketPopupNoBtn = marketPopup.querySelector("button:last-child");
const wholesaleBtn = document.querySelector("#wholesale-button");
const wholesaleCircle = document.querySelector("#wholesale-circle");
const retailBtn = document.querySelector("#retail-button");
const retailCircle = document.querySelector("#retail-circle");
const totalPriceBox = document.querySelector("#total-price-box");

let selectedProduct = null;

marketItems.forEach((item) => {
  item.addEventListener("click", () => {
    selectedProduct = item;
    marketItems = document.querySelectorAll(".market__item");
    const name = item.querySelector("span").textContent;
    marketItemName.textContent = name;
    wholesaleCircle.textContent = item.dataset.wholesaleprice;
    retailCircle.textContent = item.dataset.retailprice;
    wholesaleQuantityBox.textContent = item.dataset.quantity < wholesaleLimit ? item.dataset.quantity : wholesaleLimit;
    retailQuantityBox.textContent = item.dataset.quantity < retailLimit ? item.dataset.quantity : retailLimit;
    marketItems.forEach((item) => item.classList.remove("active"));
    item.classList.add("active");
  });
});

// WILLY
wholesaleBtn.addEventListener("click", () => {
  // Check if an item is selected before proceeding
  if (!selectedProduct) {
    console.log("Wholesale button clicked but no item selected."); 
    // ADDED: Apply shake animation to the item list
    marketContent.classList.add("shake");
    // Remove the class after the animation finishes
    setTimeout(() => {
        marketContent.classList.remove("shake");
    }, 300); // Duration should match the CSS animation duration
    return; 
  }

  const dataset = selectedProduct.dataset;
  const availableQuantity = parseInt(dataset.quantity);
  
 // WILLY: Verify if there is enough quantity for wholesale
  if (availableQuantity < wholesaleLimit) {
// WILLY: Only add the shake animation
    const buttonContainer = wholesaleBtn.closest('.market__button');
    buttonContainer.classList.add("shake");
// WILLY: Remove the class after the animation
    setTimeout(() => {
      buttonContainer.classList.remove("shake");
    }, 400); 
    
    return; // WILLY: Prevent the popup from opening
  }

// WILLY: If there is enough quantity, proceed normally
  marketPopup.classList.add("active");
  const quantity = wholesaleLimit;
  const calculatedPrice = dataset.wholesaleprice * quantity;
  totalPriceBox.textContent = currencySymbol + calculatedPrice; // Prepend currency symbol
  selectedProduct.dataset.sellType = "wholesale";
  selectedProduct.dataset.sellQuantity = quantity;
});

retailBtn.addEventListener("click", () => {
  // Check if an item is selected before proceeding
  if (!selectedProduct) {
    console.log("Retail button clicked but no item selected."); 
    // ADDED: Apply shake animation to the item list
    marketContent.classList.add("shake");
    // Remove the class after the animation finishes
    setTimeout(() => {
        marketContent.classList.remove("shake");
    }, 300); // Duration should match the CSS animation duration
    return; 
  }

  marketPopup.classList.add("active");
  const dataset = selectedProduct.dataset;
// WILLY: Limit quantity to the minimum between available quantity and retail limit
  const quantity = Math.min(dataset.quantity, retailLimit);
  // MODIFIED: Calculate price and prepend currency symbol
  const calculatedPrice = dataset.retailprice * quantity; 
  totalPriceBox.textContent = currencySymbol + calculatedPrice; 
  selectedProduct.dataset.sellType = "retail";
  selectedProduct.dataset.sellQuantity = quantity; // WILLY: Save quantity to sell
});

marketPopupYesBtn.addEventListener("click", () => {
  marketPopup.classList.remove("active");
  SendNUI("SellItem", JSON.stringify({
    jobName: currentJob, 
    itemName: selectedProduct.dataset.itemName,
    sellType: selectedProduct.dataset.sellType,
    amount: parseInt(selectedProduct.dataset.sellQuantity) // WILLY: Send limited quantity
  }));
  ShowHide(false);
  SendNUI("CloseUI");
});

marketPopupNoBtn.addEventListener("click", () => {
  marketPopup.classList.remove("active");
});

// Missions Claim buttons click
const claimBtns = document.querySelectorAll(".mission__button");

claimBtns.forEach((btn) => {
  btn.addEventListener("click", () => {
    btn.closest(".mission").remove();
  });
});

const marketContent = document.querySelector(".market__content");

const toolsContainer = document.querySelector(".tools");

// Add tool
const addTool = (imageSrc, level, name, label, price, disabled = true) => {
  tools = document.querySelectorAll(".tool");
  const id = tools.length ? tools.length + 1 : 1;
  const tool = document.createElement("div");
  tool.className = `tool ${disabled ? "disabled" : ""}`;
  tool.dataset.level = level;
  tool.id = id;
  tool.innerHTML = `
    <img
      class="tool__image"
      src=${imageSrc}
      alt="Tool"
    />
    <div class="tool__content">
      <div class="tool__title">
        <span class="tool__level">LVL ${level}</span>
        <span class="tool__name">${label}</span>
      </div>
      <div class="tool__price">${currencySymbol}${price}</div> <!-- Prepend currency symbol -->
      <button class="tool__button" data-i18n="toolBtn">Buy</button>
    </div>
    <div class="popup">
      <div class="popup__inner">
        <div class="popup__block">
          <div class="popup__title">ARE YOU SURE?</div>
        </div>
        <div class="popup__block">
          <div class="popup__buttons">
            <button data-item="${name}">Yes</button>
            <button>No</button>
          </div>
        </div>
      </div>
    </div>
    <div class="tool__status">
      <span>No Level</span>
    </div>
  `;

  toolsContainer.append(tool);

  const btn = tool.querySelector(".tool__button");
  const popup = tool.querySelector(".popup");
  const yesBtn = popup.querySelector("button:first-child");
  const noBtn = popup.querySelector("button:last-child");

  btn.addEventListener("click", () => {
    popup.classList.add("active");
  });

  yesBtn.addEventListener("click", () => {
    popup.classList.remove("active");
    ShowHide(false);
    SendNUI("BuyTool", JSON.stringify({jobType: currentType, name: name}));
  });

  noBtn.addEventListener("click", () => {
    popup.classList.remove("active");
  });
};

// Remove tool
const removeTool = (id) => {
  tools = document.querySelectorAll(".tool");
  tools.forEach((tool) => {
    if (tool.id === id.toString()) tool.remove();
  });
};
const RemoveAllTools = () => {
    tools = document.querySelectorAll(".tool");
    tools.forEach((tool) => {
        tool.remove();
    });
};

const wholesaleQuantityBox = document.querySelector("#wholesale-quantity-box");
const retailQuantityBox = document.querySelector("#retail-quantity-box");

// Add market item
const addMarketItem = (
  imageSrc,
  itemName,
  name,
  wholesalePrice,
  retailPrice,
  quantity
) => {
  marketItems = document.querySelectorAll(".market__item");
  const id = marketItems.length ? marketItems.length + 1 : 1;
  const marketItem = document.createElement("div");
  marketItem.className = "market__item";
  marketItem.id = id;
  marketItem.dataset.itemName = itemName;
  marketItem.dataset.wholesaleprice = wholesalePrice;
  marketItem.dataset.retailprice = retailPrice;
  marketItem.dataset.quantity = quantity;
  marketItem.innerHTML = `
      <img src=${imageSrc} alt="Product" />
      <span>${name}</span>
  `;
  marketContent.appendChild(marketItem);

  marketItem.addEventListener("click", () => {
    //console.log('market item clicked', quantity, retailLimit);
    selectedProduct = marketItem;
    marketItems.forEach((item) => item.classList.remove("active"));
    marketItem.classList.add("active");
    marketItemName.textContent = name;
    wholesaleCircle.textContent = wholesalePrice;
    retailCircle.textContent = retailPrice;
    wholesaleQuantityBox.textContent = quantity < wholesaleLimit ? quantity : wholesaleLimit;
    retailQuantityBox.textContent = quantity < retailLimit ? quantity : retailLimit;
  });
};

// Remove item from the market
const removeItemFromMarket = (id) => {
  marketItems = document.querySelectorAll(".market__item");
  marketItems.forEach((item) => {
    if (item.id === id.toString()) item.remove();
  });
};

const RemoveAllItemsFromMarket = () => {
  marketItems = document.querySelectorAll(".market__item");
  marketItems.forEach((item) => item.remove());
};

const missionsContent = document.querySelector(".missions__content");

// `Add` mission
const addMission = (name, action, object, xp, progress, steps, disabled = true) => {
  missions = document.querySelectorAll(".mission");
  const id = missions.length ? missions.length + 1 : 1;
  const mission = document.createElement("div");
  mission.id = id;
  mission.dataset.name = name;
  mission.className = `mission ${disabled ? "disabled" : ""}`;
  mission.innerHTML = `
    <div class="mission__xp">
      <img src="assets/svgs/gift.svg" alt="Gift" />
      <span>${xp}<strong>xp</strong></span>
    </div>
    <div class="mission__name">${action}</div>
    <button class="mission__button">Claim</button>
    <div class="mission__count">${progress}/<strong>${steps}</strong></div>
  `;
  /*mission.innerHTML = `
    <div class="mission__xp">
      <img src="assets/svgs/gift.svg" alt="Gift" />
      <span>${xp}<strong>xp</strong></span>
    </div>
    <div class="mission__name">${action} <span>${object}</span></div>
    <button class="mission__button">Claim</button>
    <div class="mission__count">${progress}/<strong>${steps}</strong></div>
  `;*/

  missionsContent.append(mission);

  const missionButton = mission.querySelector(".mission__button");
  missionButton.addEventListener("click", () => {
   SendNUI("CompleteMission", JSON.stringify({jobName: currentJob, mission: name}));
   mission.remove();
   for (let index = 0; index < missionsObject.length; index++) {
       const element = missionsObject[index];
       if(element.mission == name){
           element.claimed = 1;
       }
   }
  });
};

// Remove mission
const removeMission = (id) => {
  missions = document.querySelectorAll(".mission");
  missions.forEach((mission) => {
    if (mission.id === id.toString()) mission.remove();
  });
};

const removeAllMissions = () => {
  missions = document.querySelectorAll(".mission");
  missions.forEach((mission) => {
    mission.remove();
  });
};

// Timer
class Timer {
  constructor(callback) {
    this.callback = callback;
  }

  start() {
    this.timerId = setInterval(this.callback, 1000);
  }

  cancel() {
    if (this.timerId) {
      clearInterval(this.timerId);
      this.timerId = null;
    }
  }
}

function StartTimer(seconds) {
    const timerHours = document.querySelector(".timer__hours");
    const timerMinutes = document.querySelector(".timer__minutes");
    const timerUnit = document.querySelector(".timer__unit");

    /*const minutes = 10;
    let seconds = minutes * 60;*/

    const timer = new Timer(() => {
    seconds -= 1;

    if (seconds <= 0) {
        timer.cancel();
    }

    const formattedHours = Math.floor(seconds / 60 / 60);
    const formattedMinutes = Math.floor((seconds / 60) % 60);
    const formattedSeconds = Math.floor(seconds % 60);

    if (formattedHours >= 1) {
        timerHours.textContent =
        formattedHours < 10 ? `0${formattedHours}` : formattedHours;
        timerMinutes.textContent =
        formattedMinutes < 10 ? `0${formattedMinutes}` : formattedMinutes;
        timerUnit.textContent = "H";
    } else {
        // If hours are less than 1, show timer in minutes and seconds
        timerHours.textContent =
        formattedMinutes < 10 ? `0${formattedMinutes}` : formattedMinutes;
        timerMinutes.textContent =
        formattedSeconds < 10 ? `0${formattedSeconds}` : formattedSeconds;
        timerUnit.textContent = "M";
    }
    });

    timer.start();
}

// Set profile circle progress
const setProfileCircleProgress = (percent) => {
  const profileCircle = document.querySelector(".profile__level circle");
  // 7.85 is stroke-dasharray value
  profileCircle.style.strokeDashoffset = 7.85 - 7.85 * (percent / 100) + "rem";
};

setProfileCircleProgress(10);

// Set User Level
const userLevelCircle = document.querySelector("#user-level-circle");
const currentLevel = document.querySelector('#currentLevel');

const setUserLevel = (level) => {
    userLevelCircle.textContent = level;
    currentLevel.innerHTML = level;
  
    tools = document.querySelectorAll('.tool');
    missions = document.querySelectorAll('.mission');
  
    tools.forEach((tool) => {
        if(level >= tool.dataset.level) tool.classList.remove("disabled");
    });
  
    /*missions.forEach((mission) => {
    mission.classList.remove('disabled');
    });*/
};

const wholesaleLimitBox = document.querySelector("#wholesale-limit-box");
const retailLimitBox = document.querySelector("#retail-limit-box");

wholesaleLimitBox.textContent = wholesaleLimit;
retailLimitBox.textContent = retailLimit;

const setWholesaleRetailLimits = (_wholesaleLimit, _retailLimit) => {
  wholesaleLimitBox.textContent = _wholesaleLimit;
  retailLimitBox.textContent = _retailLimit;
  wholesaleLimit = _wholesaleLimit
  retailLimit = _retailLimit
};

const setCurrentXp = (xp) => {
    const currentXp = document.getElementById('currentXp');
    currentXp.innerHTML = xp;
};
  
const setRequiredXp = (xp) => {
    const requiredXp = document.getElementById('requiredXp');
    requiredXp.innerHTML = xp;
};

// WILLY
function ShowHide(state){
  if(state) {
      forgeJobs.classList.add("active");
  } else {
      forgeJobs.classList.remove("active");
      unselectMarketItem(); // WILLY: Call when closed
  }
}

async function SendNUI(url, json){
    let finished = false;
    let response = null;
    try {
        const resourceName = GetParentResourceName ? GetParentResourceName() : 'forge-jobs'; // Fallback resource name
        const resp = await fetch(`https://${resourceName}/${url}`, { // Use await directly
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: json
        });
        
        if (!resp.ok) {
            // Log details if response status is not OK (e.g., 404, 500)
            console.error(`SendNUI Error: Response not OK (${resp.status}) for ${url}. Status text: ${resp.statusText}`);
            // Optionally try to read the response body for more error details
            // const errorBody = await resp.text(); 
            // console.error(`SendNUI Error Body: ${errorBody}`);
            response = { error: `HTTP error ${resp.status}`, ok: false };
        } else {
             // Try to parse JSON, catch error if body is not valid JSON
            try {
                 response = await resp.json();
            } catch (jsonError) {
                 console.error(`SendNUI Error: Failed to parse JSON response for ${url}.`, jsonError);
                 // Attempt to read as text for debugging
                 // const textResponse = await resp.text(); 
                 // console.error(`SendNUI Text Response: ${textResponse}`);
                 response = { error: 'Invalid JSON response', ok: false };
            }
        }

    } catch (error) {
        // Catch network errors or other issues with fetch itself
        console.error(`SendNUI Fetch Error for ${url}:`, error);
        response = { error: error.message || 'Failed to fetch', ok: false };
    }
    
    // No need for the while loop anymore as we use await
    // finished = true; 

    return response;
}

const delay = (delayInms) => {
    return new Promise(resolve => setTimeout(resolve, delayInms));
};