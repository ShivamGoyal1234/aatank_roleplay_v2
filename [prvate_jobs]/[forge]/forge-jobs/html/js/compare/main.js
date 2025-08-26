const root = document.documentElement;
const pageNumber = 5;
const instructions = document.querySelectorAll('.instruction');
let tools = document.querySelectorAll('.tool');
let missions = document.querySelectorAll('.mission');

let wholesaleLimit = 1500;
let retailLimit = 5;

const instructionTexts = [
  [
    'Go to the <span>gathering points</span> in the areas marked on the map and mine as many rocks as you want.',
    "Then you'll need to <span>wash those stones</span> in the washing area to better reveal the minerals hidden inside.",
    'Once your stones are washed, take them to the <span>machine to transform</span> and sell them.',
  ],
  [
    'Go to the <span>hunting spots</span> and kill the prey to then collect all the items they can give you!',
    'After this, you will need to take your items to be <span>washed or to manage their processing</span>.',
    'When you have all your items, remember to take them to the <span>final process!</span>',
  ],
  [
    'Go to the <span>sea and start fishing</span> with your fishing rod, be patient and do it properly!',
    'After this, go to the appropriate place to <span>wash and process the fish</span> you’ve caught.',
    "Once you’ve done that, don't forget to go to the factory to turn them into the <span>final item you’ll sell</span>.",
  ],
  [
    'Go to the <span>chopable forest</span> and then, with your tool, chop all the wood you can!',
    "Once you've done this, go to the <span>machine to remove the bark</span> from the wood.",
    'Once you’ve done this, go to the <span>machine to process the wood</span> so you can sell it.',
  ],
  [
    'Go to the harvest area and <span>harvest</span> all the vegetables you can.',
    'Once you have the vegetables, go <span>wash</span> them and prepare them for processing.',
    'Now, turn that clean product into a <span>good product that sells</span> well in the market.',
  ],
  [
    'Go to the <span>trash or scrap areas</span> to collect recyclable items.',
    'Now go to perform the <span>first processing of those items</span>, of course. You will receive another item.',
    'The final process will be to turn those items into a <span>final item</span> that you can sell at a very good price.',
  ],
];

const missionNames = [
  [
    'Mine <span>10 stones</span>',
    'Mine <span>35 stones</span>',
    'Wash <span>10 stones</span>',
  ],
  [
    'Hunt <span>10 pieces</span>',
    'Hunt <span>35 pieces</span>',
    'Hunt <span>10 pieces</span>',
  ],
  [
    'Fish <span>10 fish</span>',
    'Fish <span>35 fish</span>',
    'Fish <span>10 fish</span>',
  ],
  [
    'Chop <span>10 logs</span>',
    'Chop <span>35 logs</span>',
    'Chop <span>10 logs</span>',
  ],
  [
    'Pick <span>10 vegetables</span>',
    'Pick <span>35 vegetables</span>',
    'Pick <span>10 vegetables</span>',
  ],
  [
    'Search <span>10 trashes</span>',
    'Search <span>35 trashes</span>',
    'Search <span>10 trashes</span>',
  ],
];

// Translation
function updateContent() {
  document.querySelectorAll('[data-i18n]').forEach((element) => {
    const key = element.getAttribute('data-i18n');
    element.innerHTML = i18next.t(key);
  });
}

i18next.use(i18nextBrowserLanguageDetector).init(
  {
    resources: {
      en: {
        translation: {
          navBtn1: 'home',
          navBtn2: 'tool',
          navBtn3: 'market',
          navBtn4: 'missions',
          toolsTitle: 'buy your tool',
          marketTitle: 'sell the goods',
          missionsTitle: 'some missions',
          instructionBtn: 'Mark on the map',
          toolBtn: 'buy',
          missionBtn: 'claim',
          marketItemName: 'You have selected',
          challengeText: `time for the<br /><span>next challenge:</span>`,
        },
      },
      de: {
        translation: {
          navBtn1: 'heim',
          navBtn2: 'werkzeug',
          navBtn3: 'markt',
          navBtn4: 'missionen',
          toolsTitle: 'kaufen sie ihr werkzeug',
          marketTitle: 'die ware verkaufen',
          missionsTitle: 'einige missionen',
          instructionBtn: 'auf der karte markieren',
          toolBtn: 'kaufen',
          missionBtn: 'beanspruchen',
          marketItemName: 'Sie haben ausgewählt',
          challengeText: `Zeit für die nächste <br /><span>Herausforderung</span>`,
        },
      },
    },
    fallbackLng: 'en',
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
    document.querySelectorAll('[data-i18n]').forEach((element) => {
      const key = element.getAttribute('data-i18n');
      element.innerHTML = i18next.t(key);
    });
  });
}

switch (pageNumber) {
  case 1:
    {
      root.style.setProperty('--primary-color', '#FF0451');
      instructions.forEach((instruction, i) => {
        instruction.querySelector('.instruction__text').innerHTML =
          instructionTexts[0][i];
        instruction.querySelector(
          '.instruction__bottom-bg img'
        ).src = `../assets/images/instructions/1-${i + 1}.png`;
      });
      tools.forEach((tool) => {
        tool.querySelector('.tool__name').textContent = 'PICKAXE';
        tool.querySelector('.tool__image').src = '../assets/images/tools/1.png';
      });
      missions.forEach((mission, i) => {
        mission.querySelector('.mission__name').innerHTML = missionNames[0][i];
      });
      i18next.addResource('en', 'translation', 'headingName', 'mining');
      i18next.addResource('de', 'translation', 'headingName', 'bergbau');
      updateContent();
    }
    break;
  case 2:
    {
      root.style.setProperty('--primary-color', '#FF6D04');
      instructions.forEach((instruction, i) => {
        instruction.querySelector('.instruction__text').innerHTML =
          instructionTexts[1][i];
        instruction.querySelector(
          '.instruction__bottom-bg img'
        ).src = `../assets/images/instructions/2-${i + 1}.png`;
      });
      tools.forEach((tool) => {
        tool.querySelector('.tool__name').textContent = 'RIFLE';
        tool.querySelector('.tool__image').src = '../assets/images/tools/2.png';
      });
      missions.forEach((mission, i) => {
        mission.querySelector('.mission__name').innerHTML = missionNames[1][i];
      });
      i18next.addResource('en', 'translation', 'headingName', 'hunting');
      i18next.addResource('de', 'translation', 'headingName', 'jagd');
      updateContent();
    }
    break;
  case 3:
    {
      root.style.setProperty('--primary-color', '#04ABFF');
      instructions.forEach((instruction, i) => {
        instruction.querySelector('.instruction__text').innerHTML =
          instructionTexts[2][i];
        instruction.querySelector(
          '.instruction__bottom-bg img'
        ).src = `../assets/images/instructions/3-${i + 1}.png`;
      });
      tools.forEach((tool) => {
        tool.querySelector('.tool__name').textContent = 'FISHING ROD';
        tool.querySelector('.tool__image').src = '../assets/images/tools/3.png';
      });
      missions.forEach((mission, i) => {
        mission.querySelector('.mission__name').innerHTML = missionNames[2][i];
      });
      i18next.addResource('en', 'translation', 'headingName', 'fishing');
      i18next.addResource('de', 'translation', 'headingName', 'angeln');
      updateContent();
    }
    break;
  case 4:
    {
      root.style.setProperty('--primary-color', '#8F3200');
      instructions.forEach((instruction, i) => {
        instruction.querySelector('.instruction__text').innerHTML =
          instructionTexts[3][i];
        instruction.querySelector(
          '.instruction__bottom-bg img'
        ).src = `../assets/images/instructions/4-${i + 1}.png`;
      });
      tools.forEach((tool) => {
        tool.querySelector('.tool__name').textContent = 'AXE';
        tool.querySelector('.tool__image').src = '../assets/images/tools/4.png';
      });
      missions.forEach((mission, i) => {
        mission.querySelector('.mission__name').innerHTML = missionNames[3][i];
      });
      i18next.addResource('en', 'translation', 'headingName', 'lumberjack');
      i18next.addResource('de', 'translation', 'headingName', 'holzfäller');
      updateContent();
    }
    break;
  case 5: {
    root.style.setProperty('--primary-color', '#5CFF4E');
    instructions.forEach((instruction, i) => {
      instruction.querySelector('.instruction__text').innerHTML =
        instructionTexts[4][i];
      instruction.querySelector(
        '.instruction__bottom-bg img'
      ).src = `../assets/images/instructions/5-${i + 1}.png`;
    });
    tools.forEach((tool) => {
      tool.querySelector('.tool__name').textContent = 'TROWEL';
      tool.querySelector('.tool__image').src = '../assets/images/tools/1.png';
    });
    missions.forEach((mission, i) => {
      mission.querySelector('.mission__name').innerHTML = missionNames[4][i];
    });
    i18next.addResource('en', 'translation', 'headingName', 'farming');
    i18next.addResource('de', 'translation', 'headingName', 'land');
    updateContent();
    break;
  }
  case 6: {
    root.style.setProperty('--primary-color', '#A9A9A9');
    instructions.forEach((instruction, i) => {
      instruction.querySelector('.instruction__text').innerHTML =
        instructionTexts[5][i];
      instruction.querySelector(
        '.instruction__bottom-bg img'
      ).src = `../assets/images/instructions/6-${i + 1}.png`;
    });
    tools.forEach((tool) => {
      tool.querySelector('.tool__name').textContent = 'RECYCLER';
      tool.querySelector('.tool__image').src = '../assets/images/tools/1.png';
    });
    missions.forEach((mission, i) => {
      mission.querySelector('.mission__name').innerHTML = missionNames[5][i];
    });
    i18next.addResource('en', 'translation', 'headingName', 'recycling');
    i18next.addResource('de', 'translation', 'headingName', 'recycling');
    updateContent();
  }
}

const forgeJobs = document.querySelector('.forge-jobs');

// Close UI button click
const closeBtn = document.querySelector('.nav__close');

closeBtn.addEventListener('click', () => {
  forgeJobs.classList.remove('active');
});

// Instruction buttons click
const instructionBtns = document.querySelectorAll('.instruction__button');

instructionBtns.forEach((btn) => {
  btn.addEventListener('click', () => {
    forgeJobs.classList.remove('active');
  });
});

// Navigation buttons click
const navBtns = document.querySelectorAll('.nav__button');
const menuBlocks = document.querySelectorAll('.menu__block');

navBtns.forEach((btn, i) => {
  btn.addEventListener('click', () => {
    navBtns.forEach((btn) => btn.classList.remove('active'));
    menuBlocks.forEach((block) => block.classList.remove('active'));

    btn.classList.add('active');
    menuBlocks[i].classList.add('active');
  });
});

// Tool buttons click
const toolBtns = document.querySelectorAll('.tool__button');

toolBtns.forEach((btn) => {
  const popup = btn.closest('.tool').querySelector('.popup');
  const yesBtn = popup.querySelector('button:first-child');
  const noBtn = popup.querySelector('button:last-child');

  btn.addEventListener('click', () => {
    popup.classList.add('active');
  });

  yesBtn.addEventListener('click', () => {
    popup.classList.remove('active');
  });

  noBtn.addEventListener('click', () => {
    popup.classList.remove('active');
  });
});

// Market Items click
let marketItems = document.querySelectorAll('.market__item');
const marketItemName = document.querySelector('#marketItem-name');
const marketPopup = document.querySelector('.market .popup');
const marketPopupYesBtn = marketPopup.querySelector('button:first-child');
const marketPopupNoBtn = marketPopup.querySelector('button:last-child');
const wholesaleBtn = document.querySelector('#wholesale-button');
const wholesaleCircle = document.querySelector('#wholesale-circle');
const retailBtn = document.querySelector('#retail-button');
const retailCircle = document.querySelector('#retail-circle');
const totalPriceBox = document.querySelector('#total-price-box');

let selectedProduct = null;

marketItems.forEach((item) => {
  item.addEventListener('click', () => {
    selectedProduct = item;
    marketItems = document.querySelectorAll('.market__item');
    const name = item.querySelector('span').textContent;
    marketItemName.textContent = name;
    wholesaleCircle.textContent = item.dataset.wholesaleprice;
    retailCircle.textContent = item.dataset.retailprice;
      wholesaleQuantityBox.textContent = item.dataset.quantity < wholesaleLimit ? item.dataset.quantity : wholesaleLimit;
    retailQuantityBox.textContent = item.dataset.quantity < retailLimit ? item.dataset.quantity : retailLimit;
    marketItems.forEach((item) => item.classList.remove('active'));
    item.classList.add('active');
  });
});

wholesaleBtn.addEventListener('click', () => {
  marketPopup.classList.add('active');
  const dataset = selectedProduct.dataset;
  totalPriceBox.textContent = dataset.wholesaleprice * dataset.quantity;
});

retailBtn.addEventListener('click', () => {
  marketPopup.classList.add('active');
  const dataset = selectedProduct.dataset;
  totalPriceBox.textContent = dataset.retailprice * dataset.quantity;
});

marketPopupYesBtn.addEventListener('click', () => {
  marketPopup.classList.remove('active');
});

marketPopupNoBtn.addEventListener('click', () => {
  marketPopup.classList.remove('active');
});

// Missions Claim buttons click
const claimBtns = document.querySelectorAll('.mission__button');

claimBtns.forEach((btn) => {
  btn.addEventListener('click', () => {
    btn.closest('.mission').remove();
  });
});

const marketContent = document.querySelector('.market__content');

const toolsContainer = document.querySelector('.tools');

// Add tool
const addTool = (imageSrc, level, name, price, disabled = true) => {
  tools = document.querySelectorAll('.tool');
  const id = tools.length ? tools.length + 1 : 1;
  const tool = document.createElement('div');
  tool.className = `tool ${disabled ? 'disabled' : ''}`;
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
        <span class="tool__name">${name}</span>
      </div>
      <div class="tool__price">$${price}</div>
      <button class="tool__button" data-i18n="toolBtn">Buy</button>
    </div>
    <div class="popup">
      <div class="popup__inner">
        <div class="popup__block">
          <div class="popup__title">ARE YOU SURE?</div>
        </div>
        <div class="popup__block">
          <div class="popup__buttons">
            <button>Yes</button>
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

  const btn = tool.querySelector('.tool__button');
  const popup = tool.querySelector('.popup');
  const yesBtn = popup.querySelector('button:first-child');
  const noBtn = popup.querySelector('button:last-child');

  btn.addEventListener('click', () => {
    popup.classList.add('active');
  });

  yesBtn.addEventListener('click', () => {
    popup.classList.remove('active');
  });

  noBtn.addEventListener('click', () => {
    popup.classList.remove('active');
  });
};

// Remove tool
const removeTool = (id) => {
  tools = document.querySelectorAll('.tool');
  tools.forEach((tool) => {
    if (tool.id === id.toString()) tool.remove();
  });
};

const wholesaleQuantityBox = document.querySelector('#wholesale-quantity-box');
const retailQuantityBox = document.querySelector('#retail-quantity-box');

// Add market item
const addMarketItem = (
  imageSrc,
  name,
  wholesalePrice,
  retailPrice,
  quantity
) => {
  marketItems = document.querySelectorAll('.market__item');
  const id = marketItems.length ? marketItems.length + 1 : 1;
  const marketItem = document.createElement('div');
  marketItem.className = 'market__item';
  marketItem.id = id;
  marketItem.dataset.wholesaleprice = wholesalePrice;
  marketItem.dataset.retailprice = retailPrice;
  marketItem.dataset.quantity = quantity;
  marketItem.innerHTML = `
      <img src=${imageSrc} alt="Product" />
      <span>${name}</span>
  `;
  marketContent.appendChild(marketItem);

  marketItem.addEventListener('click', () => {
    selectedProduct = marketItem;
    marketItems.forEach((item) => item.classList.remove('active'));
    marketItem.classList.add('active');
    marketItemName.textContent = name;
    wholesaleCircle.textContent = wholesalePrice;
    retailCircle.textContent = retailPrice;
       wholesaleQuantityBox.textContent = quantity < wholesaleLimit ? quantity : wholesaleLimit;
    retailQuantityBox.textContent = quantity < retailLimit ? quantity : retailLimit;
  });
};

// Remove item from the market
const removeItemFromMarket = (id) => {
  marketItems = document.querySelectorAll('.market__item');
  marketItems.forEach((item) => {
    if (item.id === id.toString()) item.remove();
  });
};

const missionsContent = document.querySelector('.missions__content');

// `Add` mission
const addMission = (action, object, xp, steps, disabled = true) => {
  missions = document.querySelectorAll('.mission');
  const id = missions.length ? missions.length + 1 : 1;
  const mission = document.createElement('div');
  mission.id = id;
  mission.className = `mission ${disabled ? 'disabled' : ''}`;
  mission.innerHTML = `
    <div class="mission__xp">
      <img src="assets/svgs/gift.svg" alt="Gift" />
      <span>${xp}<strong>xp</strong></span>
    </div>
    <div class="mission__name">${action} <span>${object}</span></div>
    <button class="mission__button">Claim</button>
    <div class="mission__count">0/<strong>${steps}</strong></div>
  `;

  missionsContent.append(mission);

  const missionButton = mission.querySelector('.mission__button');
  missionButton.addEventListener('click', () => {
    mission.remove();
  });
};

// Remove mission
const removeMission = (id) => {
  missions = document.querySelectorAll('.mission');
  missions.forEach((mission) => {
    if (mission.id === id.toString()) mission.remove();
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

const timerHours = document.querySelector('.timer__hours');
const timerMinutes = document.querySelector('.timer__minutes');
const timerUnit = document.querySelector('.timer__unit');

const minutes = 10;
let seconds = minutes * 60;

const timer = new Timer(() => {
  seconds -= 1;

  if (seconds == 0) {
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
    timerUnit.textContent = 'H';
  } else {
    // If hours are less than 1, show timer in minutes and seconds
    timerHours.textContent =
      formattedMinutes < 10 ? `0${formattedMinutes}` : formattedMinutes;
    timerMinutes.textContent =
      formattedSeconds < 10 ? `0${formattedSeconds}` : formattedSeconds;
    timerUnit.textContent = 'M';
  }
});

timer.start();

// Set profile circle progress
const setProfileCircleProgress = (percent) => {
  const profileCircle = document.querySelector('.profile__level circle');
  // 7.85 is stroke-dasharray value
  profileCircle.style.strokeDashoffset = 7.85 - 7.85 * (percent / 100) + 'rem';
};

setProfileCircleProgress(10);

// Set User Level
const userLevelCircle = document.querySelector('#user-level-circle');
const currentLevel = document.querySelector('#currentLevel');

const setUserLevel = (level) => {
  userLevelCircle.textContent = level;
  currentLevel.innerHTML = level

  if (level >= 5) {
    tools = document.querySelectorAll('.tool');
    missions = document.querySelectorAll('.mission');

    tools.forEach((tool) => {
      tool.classList.remove('disabled');
    });

    missions.forEach((mission) => {
      mission.classList.remove('disabled');
    });
  }
};

const wholesaleLimitBox = document.querySelector('#wholesale-limit-box');
const retailLimitBox = document.querySelector('#retail-limit-box');

wholesaleLimitBox.textContent = wholesaleLimit;
retailLimitBox.textContent = retailLimit;

const setWholesaleRetailLimits = (wholesaleLimit, retailLimit) => {
  wholesaleLimitBox.textContent = wholesaleLimit;
  retailLimitBox.textContent = retailLimit;
};

// Ser xp --------------------------------------------
const setCurrentXp = () => {
  const currentXp = document.getElementById('currentXp');
  let xp = 1800;
  currentXp.innerHTML = `<small>${xp}</small><em>xp</em>`;
};

const setRequiredXp = () => {
  const requiredXp = document.getElementById('requiredXp');
  let xp = 10000;
  requiredXp.innerHTML = `${xp}<em>xp</em>`;
};
