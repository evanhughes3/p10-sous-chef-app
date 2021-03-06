$(document).ready(function() {

  $("#search-form").submit(function(event){
    event.preventDefault();
    var keywords = $('#input-text').val();

    $.ajax({
      type: 'GET',
      url: '/searchResults/' + keywords,
      dataType: 'json',
    })
    .done(function (response) {
      console.log(response)
      $('#results').empty();
      displayAllRecipes(response)
    })
    .fail(function(response){
      $('#results').empty();
      $('#results').append("<h3 class='user-message'>No results were found</h3>");
    })
  })

  // $('body').on('click', '.viewRecipe', displayRecipe);


  $('.create-recipe-form').on("submit", function(event){
    event.preventDefault();
    var ingredient_array = []
    $('.ingredient-text').each(function(){
      ingredient_array.push($(this).val())
    })
    var recipeName = $('.recipe-name').val()
    var recipeInstructions = $('.recipe-instructions').val()

    $.ajax ({
      type: "POST",
      url: "/recipe/create",
      data: {ingredient : ingredient_array, recipe_name : recipeName, instructions : recipeInstructions}
    })
    .done(function(response){
      console.log("Success create recipe")
      window.location.replace('/') //SORRY!! count't figure out any other way to do this...
    })
    .fail(function(){
      console.log("Failed create recipe")
    })
  });

  $('.recipe-img').hover(function() {
    $('.recipe-img').addClass('blow-up');
  }, function() {
        $('.recipe-img').removeClass('blow-up');
    });


  $('body').on('click', '.add-ingredient-button', function(event){
    event.preventDefault()
    var buttonToRemove = (this)
    console.log(this);
    var ingredient_name = $('.ingredient-text').val()
    $.ajax({ //AJAX CALL NOT WORKING AFTER 1ST click
      type: "get",
      url: '/add/form/ingredient',
      data: {ingredient: ingredient_name},
    })
    .done(function(response){
      console.log("made it done")
      $(buttonToRemove).remove()
      $('.add-ingredient-form').append(response)

     })
    .fail(function(){
      console.log("failed")
    })
  })

});


function displayAllRecipes(response) {
  matches = response
  var source   = $("#recipe-template").html();
  var template = Handlebars.compile(source);

  matches.forEach(function(element) {
    var recipeId = element.id
    var img = element.imageUrlsBySize[90]
    var rating = element.rating
    var recipeName = element.recipeName
    var totalTime = element.totalTimeInSeconds

    var context = {recipeId: recipeId, imgUrl: img, rating: rating, time: (totalTime / 60), recipeName: recipeName};
    var html    = template(context);
    $('#results').append(html)
  })
}

// function displayRecipe(response) {
//   event.preventDefault()
//   id = $(this).attr('href')
//   $.ajax({
//     type: 'GET',
//     url: '/recipe/search/' + id,
//   }).done(function(response){
//     console.log("made it through");
//     console.log(response)
//     $('#results').children().remove();
//     $('#results').append(response);
//   }).fail(function(response){
//     console.log("failed display recipe")
//     console.log(response)
//   })

// }
