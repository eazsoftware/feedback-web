<!DOCTYPE html>
<html>
    <head>
        <title>Report a feedback</title>
        <jsp:include page="../jQueryScript.jsp" /> 
    </head>
    <body>
        <h2>Report a feedback</h2>
        <div id="info">
            <fieldset title="Feedback">            
                <div id="div_name">
                    <label for="name">Name:</label>
                    <input type="text" maxlength="100" name="name" id="name" />
                </div>
                <div id="div_message">
                    <label for="score">Score:</label>
                    <select id="score" name="score">
                      <option value="10">10</option>
                      <option value="9">9</option>
                      <option value="8">8</option>
                      <option value="7">7</option>
                      <option value="6">6</option>
                      <option value="5">5</option>
                      <option value="4">4</option>
                      <option value="3">3</option>
                      <option value="2">2</option>
                      <option value="1">1</option>
                    </select>                    
                </div>
                <div id="div_comment">
                    <label for="comment">Comment:</label>
                    <textarea maxlength="200" rows="5" height="100" name="comment" id="comment"></textarea>
                </div>                
            </fieldset>
            <br/>
            <button class="sendButton">Send</button>
        </div>
        <div class="result"></div> 
    </body>
</html>

    <script>
        var infoDiv = $('div#info');
        
        function print(element, strData){
            if (strData != null) {
                $(element).append('<table border=1><tr><th>Name</th><th>Score</th><th>Date</th><th>Comment</th></table>');                           
                var table = $(element).children();
                
                $(table).append($("<tr><td>"+strData.name +"</td><td>"+strData.score +"</td><td>"+strData.date +"</td><td>"+strData.comment +"</td></tr>"));
            }
            else {
                $(element).append('No data found!');
            }
            
            console.log(element);
        };        
        
        $(infoDiv).find('.sendButton').click(            
            function createFeeback() {
                $.ajax({
                    url: '/feedback-rest/feedback/feed',
                    dataType: 'json',
                    context: infoDiv,
                    data: "name=" + $("#name").val() + "&score=" + $("#score").val()+ "&comment=" + $("#comment").val(),
                    timeout: 10000,
                    type: "POST",
                    complete: function(){
                        //Ajax call completed!
                    },
                    success: function( strData ){
                        $(infoDiv).html("");
                        print($(".result"), strData);
                    },                 
                    error: function(x, t, m) {
                        $(infoDiv).html("");
                        $(".result").text( "Ajax call was NOT completed ["+t+"]" );
                    }                        
                });
                return(false);
        });            
    </script>        
