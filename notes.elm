-- notes.elm

Core Language
  Values
    ++

  Functions
    isNeg n = n <0

  If-expressions
    if x then a else b

    over9000 lvl = \
      if lvl > 9000 then 'powerful!' else 'weak!'

  Lists
    homogeneous
    library methods eg
      .empty
      .length
      .reverse

    double n = n*2
    List.map double [1,2,3,4]
    > [2, 6, 8, 10]

  Tuples
    heterogeneous

  Records
    -- vs Objects
    cannot access nonexistent fields
    no undefined/null fields
    cannot create recursive w/ this/self
    strict separates data <-> logic

    bill = {
      age = 57,
      name = 'Gates',
    }
    List.map .name [bill, bill, bill]
    > ['Gates', 'Gates', 'Gates']
    -- pattern-matching
    under70 {age} = age < 70
    under70 bill
    > True
    -- update
    {bill | name = 'Nye'}
    > {age=57, name='Nye'}
    {bill | age = 22}
    > {age=22, name='Gates'}


Architecture
  Basic
    Model
      types
    Update
      Msg -> Model
    View
      Model -> Html Msg


  Effects
    ...as data!

    Model
      types
      Init
        (Model, Cmd Msg)
    Update
      Msg -> Model -> (Model, Cmd Msg)
    View
      Model -> Html Msg
    Subscriptions
      Model -> Sub Msg


Types
  Anon Func
    -- \ args -> func_body
    \n -> n / 2
    > (\n -> n / 2) 128
    64

  Named Func
    halve = \n -> n / 2
    > halve 32
    16

  Type annotation
    halve : Float -> Float
    halve = \n -> n / 2

  Type alias
    -- compact type-annotation
    type alias User =
      { name : String
      , bio : String
      , pic : String
      }

    hasBio User -> Bool
    hasBio user =
      String.Length user.bio > 0

    addBio String -> User -> User
    addBio bio user =
      {user | bio = bio}

  *Union Types 
    -- aka tagged-unions, Abstract-Data-Types, Effects
    -- behave like funcs

    -- linked list
    type List a = Empty | Node a (List a)
    -- binary tree
    type Tree a = Empty | Node a (Tree a) (Tree a)
    -- Boolean
    type Bool
      = T
      | F
      | Not Bool
      | And Bool Bool
      | Or Bool Bool

  Unit type
    -- placehold empty-val
    -- normal Task
    > Task error value
    -- ignore error, value, or both
    > Task () value
    > Task error ()
    > Task () ()


Error Handling
  Maybe
    -- wrap "nullable" vals
    type Maybe = Nothing | Just a
    -- optional fields
    canBuyAlcohol User -> Bool
    canBuyAlcohol user =
      case user.age of
        Nothing ->
          False

        Just age ->
          age >= 21
    -- partial-return func
    getTeenAge User -> Maybe Int
    getTeenAge user =
      case user.age of
        Nothing ->
          Nothing

        Just age ->
          if 13 <= age && age <= 18 then
            Just age

          else
            Nothing
    -- now filter returns only-valids
    > List.filterMap getTeenAge users
    .. List Int

  Result
    -- wrap "failable" logic
    type Result error value
      = Err error
      | Ok value

    view : String -> Html msg
    view userInputAge =
      case String.toInt userInputAge of
        Err msg ->
          span [class "error"] [text msg]

        Ok age ->
          if age < 0 then
            span [class "error"] [text "I bet you are older than that!"]

          else if age > 140 then
            span [class "error"] [text "Seems unlikely..."]

          else
            text "OK!"

  Task
    -- wrap async "failable" logic
    type alias Task err ok = Task err ok
    succeed : a -> Task x a
    fail : x -> Task x a




