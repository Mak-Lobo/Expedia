from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from routes import country_routes, city_routes, doc_routes, book_class_routes, book_type_routes, airport_routes, \
    passenger_routes, flights_routes, f_booking_routes, airline_routes, f_class_routes, payments_routes, \
    b_flights_routes, user_routes

app = FastAPI()

origins = ["http://localhost:8000", "http://localhost:3000"]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_methods=["*"],
    allow_headers=["*"],
)
app.include_router(country_routes.country_router)
app.include_router(city_routes.city_router)
app.include_router(doc_routes.doc_router)
app.include_router(book_class_routes.book_class_router)
app.include_router(book_type_routes.book_type_router)
app.include_router(airport_routes.airport_router)
app.include_router(passenger_routes.pass_router)
app.include_router(flights_routes.flight_router)
app.include_router(f_booking_routes.f_book_router)
app.include_router(airline_routes.airline_router)
app.include_router(f_class_routes.f_class_router)
app.include_router(payments_routes.pay_router)
app.include_router(b_flights_routes.b_flights_router)
app.include_router(user_routes.user_router)


@app.get("/")
async def welcome():
    return {"message": "Welcome. Congratualtions on connect to the database"}
