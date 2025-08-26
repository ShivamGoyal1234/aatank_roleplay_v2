# 📋 Complete Job Guide - Forge Jobs

## 🎯 Overview

Forge Jobs includes **6 unique jobs** that players can perform to earn money and experience. Each job follows a consistent structure but with specific mechanics that make them unique and interesting.

## 🔄 Universal Job Structure

All jobs follow a **4-stage main flow** that players can complete in any order they prefer:

### 1. 🖥️ User Interface (UI)
- **Custom Access**: Each job has its own exclusive UI
- **Included Features**:
  - View complete list of tasks and objectives
  - Purchase necessary tools (3 levels per job)
  - Access market to sell final products
  - Check active daily missions
  - Mark specific locations on the map
  - View level progress and experience

### 2. 🚛 Resource Gathering (Farming)
Each job has its unique method for obtaining raw materials:

#### **⛏️ Mining**
- **Activity**: Extract rocks at designated quarries
- **Tool**: Pickaxe (3 levels available)
- **Mechanic**: Skill minigame during extraction
- **Resources obtained**: Unprocessed stones

#### **🎣 Fishing**
- **Activity**: Fish in designated water bodies
- **Tool**: Fishing rod (3 levels available)
- **Mechanic**: Fishing minigame with timing system
- **Resources obtained**: Different types of fish (common, rare, epic)

#### **🦌 Hunting**
- **Activity**: Hunt wild animals and skin them
- **Tool**: Hunting rifle (3 levels available)
- **Mechanic**: Aiming and stealth system
- **Resources obtained**: Raw meat and hides

#### **🌾 Farming**
- **Activity**: Harvest crops at designated farms
- **Tool**: Hoe (3 levels available)
- **Mechanic**: Collection with specific animations
- **Resources obtained**: Fresh crops

#### **♻️ Recycling**
- **Activity**: Search through trash containers and scrapyards
- **Tool**: Recycling tool (3 levels available)
- **Mechanic**: Container searching and vehicle scrapping
- **Resources obtained**: Recyclable materials, iron, broken cans

#### **🪓 Lumberjack**
- **Activity**: Cut down trees in designated forests
- **Tool**: Axe (3 levels available)
- **Mechanic**: Tree cutting with skill system
- **Resources obtained**: Unprocessed wood

### 3. 🔧 Pre-Processing
**Initial refinement step** where raw materials are prepared:

- **Mining**: Wash rocks at washing stations to reveal minerals
- **Fishing**: Clean and cut fish at workbenches
- **Hunting**: Process raw meat at butcheries
- **Farming**: Clean and prepare crops
- **Recycling**: Sort and clean recyclable materials
- **Lumberjack**: Process raw wood into planks

**Features**:
- Skill minigames (configurable)
- Unique animations and particle effects
- Different processing locations
- Specific props and tools

### 4. ⚙️ Final Processing
**Transformation into sellable product** using specialized machinery:

- Pre-processed materials are taken to **processing machines**
- Requires a **minimum quantity** of materials (configurable)
- Produces the **highest value final product**
- Includes visual and sound effects
- Variable processing time per job

## 💰 Market System

### Sale Types
- **🏪 Retail**: High prices, limited quantities
- **📦 Wholesale**: Lower prices, large quantities

### Sellable Products
- **Final Products**: Higher value, result of complete processing
- **Byproducts**: Symbolic value, secondary or unprocessed materials
- **Special Items**: Rare items with premium prices (e.g., epic fish)

## 🎮 Interactive Mechanics

### Minigames
- **Skill System**: Timing and precision tests
- **Progress Bars**: Configurable alternative to minigames
- **Variable Difficulty**: Adjustable by job and level

### Visual Effects
- **Particles**: Unique effects for each process
- **Animations**: Realistic character movements
- **Props**: Interactive 3D objects in the world
- **Cinematic Cameras**: Immersive experience during work

## 📍 Location System

### Map Organization
- **Blip Groups**: All points from the same job share a group
- **Configurable Names**: "Mining", "Mining - Pre-processing", etc.
- **UI Marking**: Players can mark specific locations

### Included Blips
- 🎯 Starting point (Job NPC)
- 🚛 Gathering zone
- 🔧 Pre-processing station
- ⚙️ Final processing machine

## 🎖️ Progression System

### Experience and Levels
- **XP per Action**: Different amounts depending on activity
- **Unlockable Levels**: Better tools require higher levels
- **Rewards**: Better efficiency and higher earnings

### Tools by Level
| Level | Tool | Price | Reward |
|-------|------|-------|--------|
| 1     | Level I     | $50    | 1-2 items  |
| 5     | Level II    | $2,000 | 2-4 items  |
| 10    | Level III   | $7,500 | 3-6 items  |

## 🎯 Daily Missions

### Mission Types
- **Tool Usage**: Use the job tool X times
- **Collection**: Obtain X amount of resources
- **Processing**: Process X amount of materials
- **Sales**: Sell X items in retail/wholesale

### Rewards
- **Extra XP**: 50-500 experience points
- **Money**: Variable monetary rewards
- **Refresh**: Every 24 hours automatically

## 🔧 Administrative Configuration

### Job Restrictions (Optional)
- **Per Job**: Limit jobs to specific server jobs
- **Allowed Jobs List**: Granular control per activity

### Camera Customization
- **Gathering Cameras**: Effects during farming
- **Processing Cameras**: Cinematic experience
- **Configurable**: Can be disabled if desired

## 📝 Player Tips

### Efficient Strategies
1. **Start with basic tools** to understand the mechanics
2. **Complete daily missions** for extra XP
3. **Upgrade tools gradually** as you level up
4. **Combine retail and wholesale** according to your money needs
5. **Explore all jobs** to diversify income

### Earnings Optimization
- **Final products** always give more money than raw materials
- **Retail** has better price but lower volume
- **Wholesale** allows massive sales with lower margin
- **Byproducts** can be sold for additional earnings

---

*This guide covers all fundamental aspects of the job system. For specific technical configuration, check the `shared/config.lua` file.* 