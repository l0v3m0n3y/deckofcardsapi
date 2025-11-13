# deckofcardsapi
api for deckofcardsapi.com
# Example
```nim
import asyncdispatch, deckofcardsapi, json, strutils
let data = waitFor new_deck()
echo data
```

# Launch (your script)
```
nim c -d:ssl -r  your_app.nim
```
