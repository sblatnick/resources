
#MongoDB is a JSON-like database

  #import records:
  mongoimport --db dbname --collection collectionname --jsonArray --file dataInArray.json

  #Drop database:
  mongosh --eval "use dbname" --eval  "db.dropDatabase()"

  #Drop collection:
  mongosh --eval "use dbname" --eval  "db.collectionname.drop()"

  #Enter command line:
  mongosh
    #list databases:
    show databases
    #switch to database:
    use dbname
    #list collections:
    show collections
    #select one row in collection:
    db.collectionname.find({}).limit(1);
    #disconnect:
    exit


#Mongoose is a javascript ORM for MongoDB
# "Elegant MongoDB object modeling for Node.js"
# https://mongoosejs.com

