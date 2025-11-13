import asyncdispatch, httpclient, json, strutils, uri
const api = "https://www.deckofcardsapi.com/api"
var headers = newHttpHeaders({
    "Connection": "keep-alive",
    "user-agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36",
    "Host": "www.deckofcardsapi.com",
    "accept": "application/json"
})

proc new_deck*(jokersEnabled: bool = false): Future[JsonNode] {.async.} =
  let client = newAsyncHttpClient()
  client.headers = headers
  try:
    var url = api & "/deck/new/"
    if jokersEnabled:
      url.add("?jokers_enabled=true")
    
    let response = await client.get(url)
    let body = await response.body
    result = parseJson(body)
  finally:
    client.close()

proc shuffle_deck*(
  deckId: string = "new",
  deckCount: int = 1,
  cards: seq[string] = @[],
  remaining: bool = false
): Future[JsonNode] {.async.} =
  let client = newAsyncHttpClient()
  client.headers = headers
  try:
    var url = api & "/deck/"
    if deckId == "new":
      url.add("new/")
    else:
      url.add(deckId & "/")
    url.add("shuffle/?")

    if deckCount > 1:
      url.add("deck_count=" & $deckCount & "&")
    
    if cards.len > 0:
      url.add("cards=" & cards.join(",") & "&")
    
    if remaining:
      url.add("remaining=true&")

    if url[^1] in {'&', '?'}:
      url.setLen(url.len - 1)
    
    let response = await client.get(url)
    let body = await response.body
    result = parseJson(body)
  finally:
    client.close()

proc draw_cards*(
  deckId: string,
  count: int = 1
): Future[JsonNode] {.async.} =
  let client = newAsyncHttpClient()
  client.headers = headers
  try:
    let url = api & "/deck/" & deckId & "/draw/?count=" & $count
    let response = await client.get(url)
    let body = await response.body
    result = parseJson(body)
  finally:
    client.close()

proc draw_from_pile*(
  deckId: string,
  pileName: string,
  cards: seq[string] = @[],
  count: int = 0,
  location: string
): Future[JsonNode] {.async.} =
  let client = newAsyncHttpClient()
  client.headers = headers
  try:
    var url = api & "/deck/" & deckId & "/pile/" & pileName & "/draw/"
    url.add($location & "?")
    
    if cards.len > 0:
      url.add("cards=" & cards.join(",") & "&")
    elif count > 0:
      url.add("count=" & $count & "&")
    
    if url[^1] in {'&', '?'}:
      url.setLen(url.len - 1)
    
    let response = await client.get(url)
    let body = await response.body
    result = parseJson(body)
  finally:
    client.close()

proc add_to_pile*(
  deckId: string,
  pileName: string,
  cards: seq[string]
): Future[JsonNode] {.async.} =
  let client = newAsyncHttpClient()
  client.headers = headers
  try:
    let url = api & "/deck/" & deckId & "/pile/" & pileName & "/add/?cards=" & cards.join(",")
    let response = await client.get(url)
    let body = await response.body
    result = parseJson(body)
  finally:
    client.close()

proc shuffle_pile*(
  deckId: string,
  pileName: string
): Future[JsonNode] {.async.} =
  let client = newAsyncHttpClient()
  client.headers = headers
  try:
    let url = api & "/deck/" & deckId & "/pile/" & pileName & "/shuffle/"
    let response = await client.get(url)
    let body = await response.body
    result = parseJson(body)
  finally:
    client.close()

proc list_pile*(
  deckId: string,
  pileName: string
): Future[JsonNode] {.async.} =
  let client = newAsyncHttpClient()
  client.headers = headers
  try:
    let url = api & "/deck/" & deckId & "/pile/" & pileName & "/list/"
    let response = await client.get(url)
    let body = await response.body
    result = parseJson(body)
  finally:
    client.close()

proc return_cards*(
  deckId: string,
  pileName: string = "",
  cards: seq[string] = @[]
): Future[JsonNode] {.async.} =
  let client = newAsyncHttpClient()
  client.headers = headers
  try:
    var url = api & "/deck/" & deckId & "/"
    
    if pileName != "":
      url.add("pile/" & pileName & "/")
    
    url.add("return/?")
    
    if cards.len > 0:
      url.add("cards=" & cards.join(",") & "&")
    
    if url[^1] in {'&', '?'}:
      url.setLen(url.len - 1)
    
    let response = await client.get(url)
    let body = await response.body
    result = parseJson(body)
  finally:
    client.close()

proc create_partial_deck*(cards: seq[string], shuffle: bool = true): Future[JsonNode] {.async.} =
  let client = newAsyncHttpClient()
  client.headers = headers
  try:
    var url = api & "/deck/new/"
    if shuffle:
      url.add("shuffle/")
    url.add("?cards=" & cards.join(","))
    
    let response = await client.get(url)
    let body = await response.body
    result = parseJson(body)
  finally:
    client.close()
