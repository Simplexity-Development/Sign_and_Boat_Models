# Sign Models

This is a simple resource pack that adds sign models to minecraft.

The custom model data for the signs is attached to the item that would normally display that block

Basic Signs:

<ul><li>Sign : 2669000 </li>
<li>Wall Sign : 2669001 </li>
<li>Sign Post : 2669002 </li></ul>


Hanging Signs:

<ul><li>Wall Hanging Sign : 2669000</li>
<li>Hanging Sign : 2669001</li>
<li>Attached Hanging Sign : 2669002</li></ul>

As an example: 
`/summon minecraft:item_display ~ ~ ~ {item: {id: "minecraft:cherry_hanging_sign", Count: 1b, tag: {CustomModelData: 2669000}}}`

## Note:
This resource has not been designed with player usage in mind, these items currently look very bad in the inventory and GUI