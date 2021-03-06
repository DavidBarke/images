#' Offer Image for Sale
#' 
#' @template db
#' @param image_id Image id.
#' @param price Image price.
#' 
#' @family offered_images
#' 
#' @export
db_offer_image <- function(db, image_id, price) {
  entry <- tibble::tibble(
    image_id = image_id,
    price = price
  )
  
  DBI::dbAppendTable(db, "offered_images", entry)
}



#' Withdraw Image from Sale
#' 
#' @template db
#' @param image_id Image id.
#' 
#' @family offered_images
#' 
#' @export
db_withdraw_offered_image <- function(db, image_id) {
  DBI::dbExecute(
    db,
    "DELETE FROM offered_images WHERE image_id = ?",
    params = list(as.integer(image_id))
  )
}



#' Determine if Image is Offered
#' 
#' @template db
#' @param image_id Image id.
#' 
#' @family offered_images
#' 
#' @export
db_is_image_offered <- function(db, image_id) {
  tbl <- DBI::dbGetQuery(
    db,
    "SELECT image_id FROM offered_images WHERE image_id = ?",
    params = list(as.integer(image_id))
  )
  
  image_id %in% tbl$image_id
}



#' Get Offered Price for Image
#' 
#' @template db
#' @param image_id Image id.
#' 
#' @family offered_images
#' 
#' @export
db_get_offered_price <- function(db, image_id) {
  DBI::dbGetQuery(
    db,
    "SELECT price FROM offered_images WHERE image_id = ?",
    params = list(as.integer(image_id))
  )$price
}



#' Set Offered Price for Image
#' 
#' @template db
#' @param image_id Image id.
#' 
#' @family offered_images
#' 
#' @export
db_set_offered_price <- function(db, image_id, price) {
  DBI::dbExecute(
    db,
    "UPDATE offered_images SET price = ? WHERE image_id = ?",
    params = list(price, as.integer(image_id))
  )
}



#' Get Maximum Offered Price
#' 
#' @template db
#' 
#' @family offered_images
#' 
#' @export
db_get_max_offered_price <- function(db) {
  max_price <- DBI::dbGetQuery(
    db,
    "SELECT MAX(price) AS max_price FROM offered_images"
  )$max_price
  
  if (is.na(max_price)) 0 else max_price
}



#' Get Seller ID
#' 
#' @template db
#' 
#' @family offered_images
#' 
#' @export
db_get_buy_info <- function(db, image_id) {
  DBI::dbGetQuery(
    db,
    "SELECT user.rowid AS seller_id, offered_images.price
    FROM user_image
    INNER JOIN user ON user_image.user_id = user.rowid
    INNER JOIN offered_images ON user_image.image_id = offered_images.image_id
    WHERE user_image.image_id = ?",
    params = list(image_id)
  )
}
