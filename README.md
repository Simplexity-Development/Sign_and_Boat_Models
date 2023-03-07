# Minecraft Custom Entity Models Resource Pack

### Overview

This Minecraft resource pack provides usable entity models through Custom Model Data, allowing map makers and creators to display entities in ways that were previously limited. The pack is designed to be used in other resource packs, allowing users to cherry-pick the pieces they need.

### Directory Structure

The resource pack is organized by topic, with the individual resource packs contained in their respective directories. Currently, there are three groups: "signs", "boats", and "mobs". The textures for the entities are provided in the <resource pack>:item/ directory, but they are not currently set up to automatically use loaded entity textures.

### Custom Model Data

Each model is tied to the item form of itself, or its spawn egg for mobs. The first model number will always be 2669000, and any subsequent models attached to that item will increment. For example, the following command could be used to summon a cherry hanging sign

`/summon minecraft:item_display ~ ~ ~ {item: {id: "minecraft:cherry_hanging_sign", Count: 1b, tag: {CustomModelData: 2669000}}}`

### Usage

It is important to note that these models are not designed with survival use in mind and currently render poorly in the inventory and while being held. Adjustments are planned for the future, but they are not currently a priority.

### License

This resource pack is licensed under the [MIT License](https://github.com/ADHDMC/Entity_Models/blob/master/LICENSE). This means that you are free to use, modify, and distribute the pack for any purpose, including commercial use, as long as you include the original license and copyright notice in any copies or derivative works. The software is provided "as is", without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose, and noninfringement.
