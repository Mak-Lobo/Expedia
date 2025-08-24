from fastapi import FastAPI
from backend.routes import country_routes, city_routes, doc_routes, book_class_routes, book_type_routes, airport_routes

app = FastAPI()

app.include_router(country_routes.country_router)
app.include_router(city_routes.city_router)
app.include_router(doc_routes.doc_router)
app.include_router(book_class_routes.book_class_router)
app.include_router(book_type_routes.book_type_router)
app.include_router(airport_routes.airport_router)

