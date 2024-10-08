extends Node2D

# Declare member variables here.
var grid_size = 3
var current_player = "X"
var winner = ""
var grid = [
	["", "", ""],
	["", "", ""],
	["", "", ""]
]

var cursor_position = Vector2(0, 0)  # Tracks the cursor's position in the grid
var cell_size = 100  # Size of each grid cell (adjust as needed)

# Labels for the grid
var labels = []
var message_label: Label

func _ready():
	# Initialize labels and draw grid
	initialize_labels()
	message_label = Label.new()
	message_label.rect_position = Vector2(10, grid_size * cell_size + 20)  # Position it below the grid
	add_child(message_label)
	update()  # Call to update the drawing

func _process(delta):
	# Check for input
	handle_input()
	update()  # Request a redraw on input change

func handle_input():
	if Input.is_action_just_pressed("ui_up"):
		if cursor_position.y > 0:
			cursor_position.y -= 1  # Move up
		else:
			cursor_position.y = 2
	elif Input.is_action_just_pressed("ui_down"):
		if cursor_position.y == 2:
			cursor_position.y = 0  # Move up
		else:
			cursor_position.y += 1
	elif Input.is_action_just_pressed("ui_left"):
		if cursor_position.x > 0:
			cursor_position.x -= 1  # Move up
		else:
			cursor_position.x = 2
	elif Input.is_action_just_pressed("ui_right"):
		if cursor_position.x == 2:
			cursor_position.x = 0  # Move up
		else:
			cursor_position.x += 1
	elif Input.is_action_just_pressed("ui_accept") and winner == "":  # Place X or O
		place_mark()
	elif Input.is_action_just_pressed("ui_cancel") and winner != "":  # Reset the game
		reset_board()

func initialize_labels():
	for row in range(grid_size):
		labels.append([])
		for col in range(grid_size):
			var label = Label.new()
			label.rect_position = Vector2(col * cell_size, row * cell_size)
			label.rect_size = Vector2(cell_size, cell_size)
			label.align = Label.ALIGN_CENTER
			label.valign = Label.VALIGN_CENTER
			label.autowrap = true  # Allow wrapping for text
			# Increase the font size
			var font = DynamicFont.new()
			font.font_data = load("res://funFont.ttf")
			font.size = 48  # Set font size to fill the cell
			label.set("custom_fonts/font", font)  # Apply the new font
			add_child(label)
			labels[row].append(label)


func place_mark():
	var x = int(cursor_position.x)
	var y = int(cursor_position.y)

	# Only place a mark if the cell is empty
	if grid[y][x] == "":
		grid[y][x] = current_player  # Set the current player's mark in the grid
		
		# Update the label to display the mark and color it
		labels[y][x].text = current_player
		labels[y][x].add_color_override("font_color", Color(0, 0, 1) if current_player == "X" else Color(1, 0, 0))  # Set color

		# Check for a win or draw
		if check_win():
			message_label.text = "%s Wins!" % current_player
			winner = current_player
		elif is_draw():
			message_label.text = "It's a Draw!"
			winner = 'T'
		else:
			# Switch players
			current_player = "O" if current_player == "X" else "X"

func reset_board():
	# Clear the grid and labels
	for row in range(grid_size):
		for col in range(grid_size):
			grid[row][col] = ""
			labels[row][col].text = ""

	# Reset variables
	current_player = "X"
	winner = ""
	message_label.text = ""

func check_win() -> bool:
	# Check rows, columns, and diagonals for a win
	for i in range(grid_size):
		# Check rows
		if grid[i][0] != "" and grid[i][0] == grid[i][1] and grid[i][1] == grid[i][2]:
			return true
		# Check columns
		if grid[0][i] != "" and grid[0][i] == grid[1][i] and grid[1][i] == grid[2][i]:
			return true

	# Check diagonals
	if grid[0][0] != "" and grid[0][0] == grid[1][1] and grid[1][1] == grid[2][2]:
		return true
	if grid[0][2] != "" and grid[0][2] == grid[1][1] and grid[1][1] == grid[2][0]:
		return true

	return false

func is_draw() -> bool:
	# Check if all cells are filled and no winner
	for row in grid:
		if "" in row:
			return false
	return true

func _draw():
	draw_grid()
	draw_grid_lines()  # Draw grid lines
	draw_cursor()

func draw_grid():
	for row in range(grid_size):
		for col in range(grid_size):
			var x = col * cell_size
			var y = row * cell_size
			draw_rect(Rect2(x, y, cell_size, cell_size), Color(1, 1, 1))  # Draw white grid cell

func draw_grid_lines():
	var line_color = Color(0, 0, 0)  # Black color for grid lines
	for i in range(1, grid_size):
		# Draw vertical lines
		draw_line(Vector2(i * cell_size, 0), Vector2(i * cell_size, grid_size * cell_size), line_color, 2)
		# Draw horizontal lines
		draw_line(Vector2(0, i * cell_size), Vector2(grid_size * cell_size, i * cell_size), line_color, 2)

func draw_cursor():
	var cursor_x = cursor_position.x * cell_size
	var cursor_y = cursor_position.y * cell_size
	var cursor_width = cell_size
	var cursor_height = cell_size
	var border_thickness = 5  # Thickness of the cursor border

	# Draw top border
	draw_rect(Rect2(cursor_x, cursor_y, cursor_width, border_thickness), Color(0, 1, 0))  # Green top border
	# Draw bottom border
	draw_rect(Rect2(cursor_x, cursor_y + cursor_height - border_thickness, cursor_width, border_thickness), Color(0, 1, 0))  # Green bottom border
	# Draw left border
	draw_rect(Rect2(cursor_x, cursor_y, border_thickness, cursor_height), Color(0, 1, 0))  # Green left border
	# Draw right border
	draw_rect(Rect2(cursor_x + cursor_width - border_thickness, cursor_y, border_thickness, cursor_height), Color(0, 1, 0))  # Green right border
