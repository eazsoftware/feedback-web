<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Feedback admin</title>
        <jsp:include page="../jQueryScript.jsp" /> 
    </head>
    <body>
        <div id="admin">    
            <h1>Feedback admin <button class="refreshButton">Refresh</button></h1>
            <div class="result"></div> 
            <hr/>
            </br><button class="editButton">Edit</button> | <button class="deleteButton">Delete</button>
        </div>
        
        <div id="editdiv">
            <h2>Edit a feedback</h2>
            <fieldset title="Feedback"> 
                <input type="hidden" name="id" id="id" />
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
            <button class="modifyButton">Modify</button>
        </div>        
    </body>
</html>


    <script>
        var adminDiv = $('div#admin');
        var editDiv = $('div#editdiv');
        
        function print(element, strData){
            if (strData != null) {
                $(element).append('<table border=1><tr><th>Name</th><th>Score</th><th>Date</th><th>Comment</th><th>Select</th></tr></table>');                           
                var table = $(element).children();
                
                if ($.isArray(strData.cFeedback)) {
                    $.each(strData.cFeedback, function(i, feedback){               
                        $(table).append($("<tr><td>"+feedback.name +"</td><td>"+feedback.score +"</td><td>"+feedback.date +"</td><td>"+feedback.comment +"</td><td><input type='radio' name='idFeedback' value="+feedback.id+"></td></tr>"));
                    });
                }
                else {
                    $(table).append($("<tr><td>"+strData.cFeedback.name +"</td><td>"+strData.cFeedback.score +"</td><td>"+strData.cFeedback.date +"</td><td>"+strData.cFeedback.comment +"</td><td><input type='radio' name='idFeedback' value="+strData.cFeedback.id+"></td></tr>"));                    
                }                
            }
            else {
                $(element).append('No data found!');
            }
        };

        $(adminDiv).find('.deleteButton').click(
            function deleteFeeback() {        
                 if ($(":radio:checked").length > 0) {
                    $.ajax({
                        url: '/feedback-rest/feedback/feed',
                        dataType: 'json',
                        context: adminDiv,
                        data: "id=" + $(":radio:checked").attr('value'),
                        timeout: 10000,
                        type: "DELETE",
                        complete: function(){
                            //Ajax call completed!
                        },
                        success: function( strData ){
                            $(this).find( ".result" ).html("");
                            print($(this).find( ".result" ), strData);
                        },                 
                        error: function(x, t, m) {
                            $(this).find( ".result" ).text( "Ajax call did NOT complete ["+t+"]" );
                        }                        
                    });
                }
                return(false);
        });

        $(adminDiv).find('.refreshButton').click(            
            function loadFeeback() {
                $.ajax({
                    url: '/feedback-rest/feedback/allfeedback',
                    dataType: 'json',
                    context: adminDiv,
                    timeout: 10000,
                    type: "POST",
                    complete: function(){
                        //Ajax call completed!
                    },
                    success: function( strData ){
                        $(this).find( ".result" ).html("");
                        print($(this).find( ".result" ), strData);
                    },                 
                    error: function(x, t, m) {
                        $(this).find( ".result" ).text( "Ajax call was NOT completed ["+t+"]" );
                    }                        
                });
                return(false); // Prevent default click.
        });
        
        $(editDiv).find('.modifyButton').click(            
            function modifyFeeback() {
                $.ajax({
                    url: '/feedback-rest/feedback/feed',
                    dataType: 'json',
                    context: adminDiv,
                    data: "id=" + $("#id").val() + "&name=" + $("#name").val() + "&score=" + $("#score").val()+ "&comment=" + $("#comment").val(),
                    timeout: 10000,
                    type: "PUT",
                    complete: function(){
                        //Ajax call completed!
                    },
                    success: function( strData ){
                        $(this).find( ".result" ).html("");
                        print($(this).find( ".result" ), strData);
                        $(editDiv).hide();
                        $(adminDiv).show();
                        $(adminDiv).find('.refreshButton').click();                         
                    },                 
                    error: function(x, t, m) {
                        $(this).find( ".result" ).text( "Ajax call was NOT completed ["+t+"]" );
                    }                        
                });
                return(false);
        });

        $(adminDiv).find('.editButton').click(            
            function editFeeback() {
                if ($(":radio:checked").length > 0) {
                    $(adminDiv).hide();
                    $(editDiv).show();
                    
                    $("#id").val($(":radio:checked").val());
                    $("#name").val($(":radio:checked").parent().siblings().eq(0).html());
                    $("#score").val($(":radio:checked").parent().siblings().eq(1).html());
                    $("#comment").val($(":radio:checked").parent().siblings().eq(3).html());
                }                
                return(false);
        });
        

        $(document).ready(function () {        
            $(adminDiv).find('.refreshButton').click();
            $(editDiv).hide();
        }); 
        
    </script>
