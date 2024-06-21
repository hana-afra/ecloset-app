from flask import Flask, request
import json
from supabase import create_client, Client

app = Flask(__name__)

#This is the very stupid way to store private/confidential data inside GIT
#Store inside a file to be ignored
url="https://jzredydxgjflzlgkamhn.supabase.co"
key="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp6cmVkeWR4Z2pmbHpsZ2thbWhuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDIzMDQ1OTYsImV4cCI6MjAxNzg4MDU5Nn0.7jYAyMpWdzAnyioSoVkJiRFWzWyZvs0kdDxlli02er4"
supabase: Client = create_client(url, key)

#fetch clothes types
@app.route('/types.get')
def api_types_get(): 
   response = supabase.table('type').select('*').execute()
   return json.dumps(response.data)

#fetch wilayas
@app.route('/wilayas.get')
def api_wilayas_get(): 
   response = supabase.table('wilaya').select('*').execute()
   return json.dumps(response.data)

#fetch communes
@app.route('/communes.get')
def api_communes_get(): 
   id_wilaya = request.args.get('id_wilaya', type=int)
   response = supabase.table('commune').select('*').eq('id_wilaya', id_wilaya).execute()
   return json.dumps(response.data)

@app.route('/item_user.get')
def api_itemuser_get(): 
   response = supabase.table('item').select("*, user: user(name, phone, profile_picture)").execute()
   return json.dumps(response.data)


#fetch all items
@app.route('/item.get')
def api_item_get(): 
   response = supabase.table('item').select("*, user: user(name, phone, profile_picture),wilaya(name),commune(name),type(name),category(name))").execute()
   return json.dumps(response.data)

#fetch all dresses
@app.route('/dresses.get')
def api_dresses_get(): 
    response = supabase.table('item').select("*,user: user(name, phone, profile_picture),wilaya(name),commune(name),type(name),category(name))").eq('id_type', 1).execute()
    return json.dumps(response.data)


#fetch all pants
@app.route('/pants.get')
def api_pants_get(): 
   response = supabase.table('item').select("*,user: user(name, phone, profile_picture),wilaya(name),commune(name),type(name),category(name))").eq('id_type', 2).execute()
   return json.dumps(response.data)

#fetch all shoes
@app.route('/shoes.get')
def api_shoes_get(): 
   response = supabase.table('item').select("*,user: user(name, phone, profile_picture),wilaya(name),commune(name),type(name),category(name))").eq('id_type', 3).execute()
   return json.dumps(response.data)

#fetch all tops
@app.route('/tops.get')
def api_tops_get(): 
   response = supabase.table('item').select("*,user: user(name, phone, profile_picture),wilaya(name),commune(name),type(name),category(name))").eq('id_type', 4).execute()
   return json.dumps(response.data)

@app.route('/favorite_item.add')
def api_favorite_item_add(): 
   id_user= request.args.get('id_user')
   id_item= request.args.get('id_item')
   error =False
   if (not error):   
       response = supabase.table('liked_item').insert({"id_user": id_user, "id_item": id_item}).execute()
       print(str(response.data))
       if len(response.data)==0:
           error='Error adding a liked item'       
   if error:
       return json.dumps({'status':500,'message':error})       
  
   return json.dumps({'status':200,'message':'','data':response.data})

@app.route('/selling_item.remove')
def api_selling_item_remove(): 
    id_user = request.args.get('id_user')
    id_item = request.args.get('id_item')
    error = False

    if not error:
        response = supabase.table('item').delete().eq('id_user', id_user).eq('id_item', id_item).execute()
        print(str(response.data))
        if len(response.data) == 0:
            error = 'Error removing an item'

    if error:
        return json.dumps({'status': 500, 'message': error})

    return json.dumps({'status': 200, 'message': '', 'data': response.data})

@app.route('/favorite_item.remove')
def api_favorite_item_remove(): 
    id_user = request.args.get('id_user')
    id_item = request.args.get('id_item')
    error = False

    if not error:
        response = supabase.table('liked_item').delete().eq('id_user', id_user).eq('id_item', id_item).execute()
        print(str(response.data))
        if len(response.data) == 0:
            error = 'Error removing a liked item'

    if error:
        return json.dumps({'status': 500, 'message': error})

    return json.dumps({'status': 200, 'message': '', 'data': response.data})
#liked item

@app.route('/fetch_liked_items')
def api_fetch_liked_items():
    id_user = request.args.get('id_user')
    error = False

    if not id_user:
        error = 'id_user parameter is required.'

    if not error:
        response = supabase.table('liked_item').select('*, item(*,  user: user(name, phone, profile_picture),wilaya(name),commune(name),type(name),category(name))').eq('id_user', id_user).execute()

        return json.dumps(response.data)


@app.route('/fetch_my_selling_items')
def api_fetch_my_selling_items():
    id_user = request.args.get('id_user')
    error = False

    if not id_user:
        error = 'id_user parameter is required.'

    if not error:
        response = supabase.table('item').select('*,  user: user(name, phone, profile_picture),wilaya(name),commune(name),type(name),category(name)').eq('id_user', id_user).execute()

        return json.dumps(response.data)

@app.route('/fetch_liked_item_status')
def api_fetch_liked_item_status():
    id_user = request.args.get('id_user')
    id_item = request.args.get('id_item')
    error = False

    if not id_user or not id_item:
        error = 'Both id_user and id_item parameters are required.'

    if not error:
        response = supabase.table('liked_item').select('id_user', 'id_item').eq('id_user', id_user).eq('id_item', id_item).execute()
        print(str(response.data))
        
        # Check if the response contains any data to determine if the item is liked
        is_liked = len(response.data) > 0

        return json.dumps({'status': 200, 'message': '', 'data': {'is_liked': is_liked}})

    return json.dumps({'status': 500, 'message': error})


# Update user profile
@app.route('/user.update_profile', methods=['POST', 'GET'])  
def api_user_update_profile():    
    user_id = request.args.get('id_user')  
    name = request.args.get('name')    
    email = request.args.get('email')  
    phone = request.args.get('phone')  
    error = False  
    # Add your validation logic here if needed  
    # if not user_id:        error = 'User ID is required.'  
    if not error:  
        try:           
            # Example: Your Supabase API endpoint for updating user profile  
            response = supabase.table('user').update({                
                'name': name,  
                'email': email,                
                'phone': phone,  
            }).eq('id_user', user_id).execute()  
            if len(response.data) == 0:                
                error = 'Error updating user profile.'  
        except Exception as e:            
            error = f'Unexpected error occurred: {e}'  
    # Return JSON response  
    if error:        
        return json.dumps({'status': 500, 'message': error})  
    return json.dumps({'status': 200, 'message': 'User profile updated successfully'})



@app.route('/item.upload',methods=['GET','POST'])
def api_item_upload():
   name= request.args.get('name')
   price= request.args.get('price')
   size= request.args.get('size')
   image_path= request.args.get('image_path')
   description= request.args.get('description')
   id_wilaya= request.args.get('id_wilaya')
   id_category= request.args.get('id_category')
   id_commune= request.args.get('id_commune')
   id_type= request.args.get('id_type')
   id_user= request.args.get('id_user')

   error =False
#    if (not email) or (len(email)<5): #You can even check with regx
#        error='Email needs to be valid'
#    if (not error) and ( (not password) or (len(password)<5) ):
#        error='Provide a password'       
#    if (not error):   
#        response = supabase.table('users').select("*").ilike('email', email).execute()
#        if len(response.data)>0:
#            error='User already exists'
   if (not error):   
       response = supabase.table('item').insert({"name": name, "price": price, "size": size, "description": description, "id_user": id_user, "id_commune": id_commune, "id_wilaya": id_wilaya, "id_type" : id_type, "id_category": id_category, "image_path": image_path}).execute()
       print(str(response.data))
       if len(response.data)==0:
           error='Error creating the user'       
   if error:
       return json.dumps({'status':500,'message':error})       
  
   return json.dumps({'status':200,'message':'','data':response.data})

#search endpoint
@app.route('/search', methods=['GET'])
def api_search():
    search_query = request.args.get('query')

    if not search_query:
        return json.dumps({'status': 400, 'message': 'Search query is required'}), 400

    # You can customize this query based on your Supabase schema
    response = supabase.table('item').select("*,user: user(name, phone, profile_picture),wilaya(name),commune(name),type(name),category(name))").ilike('name', f'%{search_query}%').execute()
    return json.dumps(response.data)



#filter endpoint

@app.route('/filter', methods=['GET', 'POST'])
def apply_filter():
    # Extract parameters from the request
    id_category = request.args.get('id_category')
    id_type = request.args.get('id_type')
    id_wilaya = request.args.get('id_wilaya')
    id_commune = request.args.get('id_commune')
    size = request.args.get('size')
    minPrice = request.args.get('minPrice')
    maxPrice = request.args.get('maxPrice')

    # Initialize error as False
    error = False

    try:
        # Construct Supabase query with all conditions
        query = supabase.table('item').select("*,user: user(name, phone, profile_picture),wilaya(name),commune(name),type(name),category(name))")

        # Add filters based on parameters if they are provided
        if id_wilaya:
            query = query.eq('id_wilaya', id_wilaya)
        if id_commune:
            query = query.eq('id_commune', id_commune)
        if id_type:
            query = query.eq('id_type', id_type)
        if id_category:
            query = query.eq('id_category', id_category)
        if size:
            query = query.eq('size', size)
        if minPrice:
            query = query.gte('price', int(minPrice))
        if maxPrice:
            query = query.lt('price', int(maxPrice))

        # Execute the query
        response = query.execute()

        # Check if any data is returned
        if len(response.data) == 0:
            error = 'No matching items found'

    except Exception as e:
        # Handle exceptions, set error flag, and log the exception
        print(f"Error: {e}")
        error = 'Error processing the request'

    # Return JSON response
    if error:
        return json.dumps({'status': 500, 'message': error})
    return json.dumps(response.data)

#fetch clothes categories 
@app.route('/category.get') 
def api_categories_get():  
   response = supabase.table('category').select('*').execute() 
   return json.dumps(response.data)

    
if __name__ == '__main__':
    app.debug = True
    app.run()

#signup

import re
@app.route('/user.signup', methods=['GET', 'POST'])
def api_users_signup():
    email = request.args.get('email')
    password = request.args.get('password')
    name = request.args.get('name')
    phone = request.args.get('phone')

    error = False

    # Email validation with regex
    if not email or not isinstance(email, str) or (not re.match(r'^[\w\.-]+@[\w\.-]+\.\w+$', email)):
        error = 'Email format is invalid'

    # Password validation
    if (not error) and ((not password) or (len(password) < 5)):
        error = 'Provide a password'

    # Phone number validation with regex
    if (not error) and (not re.match(r'^(05|06|07)\d{8}$', phone)):
        error = 'Phone number format is invalid'

    if not error:
        response = supabase.table('user').select("*").ilike('email', email).execute()
        if len(response.data) > 0:
            error = 'User already exists'
            return json.dumps({'status': 400, 'message': error})

    # Inserting into 'user' table
    user_insertion = supabase.table('user').insert({"name": name, "email": email, "phone": phone, "password": password}).execute()
    print("douaa")

    # Check if the user insertion was successful
    if len(user_insertion.data) == 0:
        error = 'Error creating the user'
    else:
        # If user creation was successful, proceed to create auth
        print(str(email))
        auth_response = supabase.auth.sign_up({"email" : email, "password": password})
        if 'error' in auth_response:
            error = 'Error creating authentication'
        else:
            # Both user and auth creations were successful
            print("douaa")
            print(str(auth_response))
    if error:
        return json.dumps({'status': 500, 'message': error})

    # Assuming user creation was successful and no error occurred
    print("sucess")
    return json.dumps({'status': 200, 'message': '', 'data': user_insertion.data})



#login
@app.route('/users.login',methods=['GET','POST'])
def api_users_login():
   email= request.args.get('email')
   password= request.args.get('password')
   error =False
   if not email or not isinstance(email, str) or (not re.match(r'^[\w\.-]+@[\w\.-]+\.\w+$', email)):
       error='Email needs to be valid'
   if (not error) and ( (not password) or (len(password)<5) ):
       error='Provide a password'
   if (not error):
       response = supabase.table('user').select("*").ilike('email', 
											email).eq('password',password).execute()

       if len(response.data)>0:
           return json.dumps({'status':200,'message':'','data':response.data})
             
   if not error:
        error='Invalid Email or password'
  
   return json.dumps({'status':500,'message':error})
#followers

@app.route('/get_followers_count', methods=['GET','POST'])
def get_followers_count():
    user_id = request.args.get('id_user')

    if not user_id:
        return json.dumps({'status': 400, 'message': 'user_id is required.'})

    # Get the count of followers for the user
    response = supabase.table('followers').select('*').eq('followed_id', user_id).execute()

    print("Full Response:", response)  # Add this line to print the entire response content

    # Initialize followers_count with a default value
    followers_count = 0
    if len(response.data):
        data = len(response.data)   
        print("Data:", data)
        followers_count = data
    return json.dumps({'status': 200, 'followers_count': followers_count})

@app.route('/get_following_count', methods=['GET'])
def get_following_count():
    user_id = request.args.get('id_user')

    if not user_id:
        return json.dumps({'status': 400, 'message': 'user_id is required.'})
    # Initialize followers_count with a default value
    following_count = 0

    # Get the count of users the user is following
    response = supabase.table('followers').select('*').eq('follower_id', user_id).execute()
    if len(response.data):
        data = len(response.data)   
        print("Data:", data)
        following_count = data

    return json.dumps({'status': 200, 'following_count': following_count})

@app.route('/check_follow_user', methods=['GET','POST'])
def check_follow_user():
    #data = request.get_json()
    follower_id = request.args.get('follower_id')
    followed_id = request.args.get('followed_id')

    # response = supabase.table('followers').select("*").eq('follower_id',  follower_id).eq('followed_id',  followed_id).execute()
    
    # print("follower_id:", follower_id)
    # print("followed_id:", followed_id)
    # print("Supabase response:", response)


    # if len(response.data) > 0:
    #     return json.dumps({'status': 200, 'message': '', 'data': response.data})
    # else:
    #     return json.dumps({'status': 404, 'message': ' yoo User not found ', 'data': None})
    if not follower_id or not followed_id:
        return json.dumps({'status': 400, 'message': 'follower_id and followed_id are required.'})

    # Check if the user is already following the seller
    existing_follow = supabase.table('followers').select().eq('follower_id', follower_id).eq('followed_id', followed_id).execute()

    if len(existing_follow.data) > 0:
        return json.dumps({'status': 200, 'message': 'Already following this user.'})

    return json.dumps({'status': 200, 'message': ' follow user.'})

@app.route('/follow_user', methods=['GET','POST'])
def follow_user():

    follower_id = request.args.get('follower_id')
    followed_id = request.args.get('followed_id')
   
    if not follower_id or not followed_id:
        return json.dumps({'status': 400, 'message': 'follower_id and followed_id are required.'})

    # Check if the user is already following the seller
    existing_follow = supabase.table('followers').select().eq('follower_id', follower_id).eq('followed_id', followed_id).execute()

    if len(existing_follow.data) > 0:
        return json.dumps({'status': 200, 'message': 'Already following this user.'})

    # Follow the user
    supabase.table('followers').insert({'follower_id': follower_id, 'followed_id': followed_id}).execute()

    # Update followers count in the Users table
    #supabase.rpc('update_followers_count', {'user_id': followed_id})

    return json.dumps({'status': 200, 'message': 'Successfully followed user.'})

@app.route('/unfollow_user', methods=['GET','POST'])
def unfollow_user():
   
    follower_id = request.args.get('follower_id')
    followed_id = request.args.get('followed_id')

    if not follower_id or not followed_id:
        return json({'status': 400, 'message': 'follower_id and followed_id are required.'})

    # Unfollow the user
    supabase.table('followers').delete().eq('follower_id', follower_id).eq('followed_id', followed_id).execute()

    # Update followers count in the Users table
    supabase.rpc('update_followers_count', {'user_id': followed_id})

    return json.dumps({'status': 200, 'message': 'Successfully unfollowed user.'})

if __name__ == '__main__':
    app.run(debug=True)