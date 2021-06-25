"""
Makes a coordinate given latitude and longitude
#Example:

```julia
Coordinate(37.5, 67.91666)
```
"""
struct Coordinate
    latitude
    longitude
end
"""
The mapping between the coordinates of earth and indices of the image is needed to convert from one to another. In this package such mapping is referred to as a coordinate system. To define a coordinate system, you need to provide coordinates of the top-left and bottom-right pixels, and the height and the width of the image. 

Suppose the image we plan to load had 8000 rows and 7100 columns. The top-left coordinate (37.5, 67.91666) is and bottom-right (4.166, 97.5). We can use these to create a the mapping. 

```julia
top_left     = Coordinate(37.5, 67.91666)
bottom_right = Coordinate(4.166, 97.5)
height = 8000
width  = 7100
my_coordinate_system = CoordinateSystem(top_left, bottom_right, height, width)
```

Now functions can use this mapping to go from one to another. 
"""
struct CoordinateSystem
    top_left::Coordinate
    bottom_right::Coordinate 
    height::Int64
    width::Int64
end
"""
To convert from latitude to row number of an image, use the ```lat_to_row``` function. 
# Example: 
```julia
lat_to_row(my_coordinate_system, 19.6) 
```
"""
function lat_to_row(geometry::CoordinateSystem, x)
    top_left        = geometry.top_left.latitude
    bottom_right    = geometry.bottom_right.latitude
    height          = geometry.height  
    return Int(round(((x - top_left) * height / (bottom_right - top_left))))
end
"""
To convert from longitude to column number of an image use the ```long_to_column``` function. 
# Example:
```julia
long_to_column(my_coordinate_system, 73.33) 
```
"""
function long_to_column(geometry::CoordinateSystem, x)
    top_left        = geometry.top_left.longitude
    bottom_right    = geometry.bottom_right.longitude
    width           = geometry.width  
    return Int(round(((x - top_left) * width/(bottom_right - top_left))))
end
"""
To convert from row number of an image to latitude use the ```row_to_lat``` function. 
# Example:
```julia
row_to_lat(my_coordinate_system, 100) 
```
"""
function row_to_lat(geometry::CoordinateSystem, x)
    top_left        = geometry.top_left.latitude
    bottom_right    = geometry.bottom_right.latitude
    height          = geometry.height
    return  ((bottom_right - top_left)/height * x + top_left)
end
"""
To convert from column number of an image to longitude use the ```column_to_long``` function.
# Example: 
```julia
column_to_long(my_coordinate_system, 100) 
```
"""
function column_to_long(geometry::CoordinateSystem, x)
    top_left        = geometry.top_left.longitude
    bottom_right    = geometry.bottom_right.longitude
    width           = geometry.width  
    return((bottom_right - top_left)/width * x + top_left)
end
"""
Translates a coordinate system given the new top-left and bottom-right coordinates
# Example: 
```julia
column_to_long(my_coordinate_system, 100) 
```
"""
function translate_geometry(geometry::CoordinateSystem,top_left::Coordinate,bottom_right::Coordinate)
    top_left_row = lat_to_row(geometry, top_left.latitude)
    bottom_right_row = lat_to_row(geometry, bottom_right.latitude)
    bottom_right_col = long_to_column(geometry,bottom_right.longitude)
    top_left_col = long_to_column(geometry, top_left.longitude)
    height = round(bottom_right_row - top_left_row)
    width = round(bottom_right_col - top_left_col)
    return CoordinateSystem(top_left, bottom_right, height, width) 
end

global INDIA_COORDINATE_SYSTEM = CoordinateSystem(Coordinate(37.5, 67.91666), Coordinate(4.166, 97.5), 8000, 7100)
global MUMBAI_COORDINATE_SYSTEM = translate_geometry(INDIA_COORDINATE_SYSTEM,Coordinate(19.49907,72.721252),Coordinate(18.849475, 73.074187))
