import pygame
import sys

# Initialize Pygame
pygame.init()

# Game Constants
SCREEN_WIDTH, SCREEN_HEIGHT = 800, 600
FPS = 60

# Colors
RED = (255, 0, 0)
BLUE = (0, 0, 255)
GREEN = (0, 255, 0)
YELLOW = (255, 255, 0)
BROWN = (165, 42, 42)

# Player Properties
player_size = 40
player_pos = [SCREEN_WIDTH // 2, 100]
player_speed = 5
player_jump_velocity = -10
player_velocity_y = 0
player_on_ground = False

# Enemy Properties
enemy_size = 40
enemies = [{'pos': [100, 500], 'color': YELLOW}, {'pos': [300, 500], 'color': YELLOW}]

# Platform Properties
platform_height = 20
platforms = [
    {'pos': [0, 500], 'size': [200, platform_height], 'color': BROWN},
    {'pos': [300, 400], 'size': [200, platform_height], 'color': BROWN},
    # Add more platforms as needed
]

# Game Variables
gravity = 0.5
game_running = True

# Setup the screen
screen = pygame.display.set_mode((SCREEN_WIDTH, SCREEN_HEIGHT))
pygame.display.set_caption("Mario Bros Arcade Clone")

def draw_player():
    pygame.draw.rect(screen, RED, (*player_pos, player_size, player_size))

def draw_enemies():
    for enemy in enemies:
        pygame.draw.rect(screen, enemy['color'], (*enemy['pos'], enemy_size, enemy_size))

def draw_platforms():
    for platform in platforms:
        pygame.draw.rect(screen, platform['color'], (*platform['pos'], *platform['size']))

def jump():
    global player_velocity_y, player_on_ground
    if player_on_ground:
        player_velocity_y = player_jump_velocity
        player_on_ground = False

def handle_physics():
    global player_velocity_y, player_on_ground

    # Gravity
    player_velocity_y += gravity
    player_pos[1] += player_velocity_y

    # Landing on platforms
    for platform in platforms:
        if (player_pos[1] + player_size > platform['pos'][1]) and \
           (player_pos[0] + player_size > platform['pos'][0]) and \
           (player_pos[0] < platform['pos'][0] + platform['size'][0]):
            player_on_ground = True
            player_velocity_y = 0
            player_pos[1] = platform['pos'][1] - player_size
            break
    else:
        player_on_ground = False

    # Screen edges
    player_pos[0] = max(0, min(player_pos[0], SCREEN_WIDTH - player_size))
    player_pos[1] = max(0, min(player_pos[1], SCREEN_HEIGHT - player_size))

def handle_input():
    keys = pygame.key.get_pressed()
    if keys[pygame.K_LEFT]:
        player_pos[0] -= player_speed
    if keys[pygame.K_RIGHT]:
        player_pos[0] += player_speed
    if keys[pygame.K_SPACE]:
        jump()

def game_loop():
    clock = pygame.time.Clock()
    global game_running
    while game_running:
        # Handle events
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                game_running = False

        # Handle input
        handle_input()

        # Physics
        handle_physics()

        # Drawing
        screen.fill(BLUE)
        draw_platforms()
        draw_player()
        draw_enemies()
        pygame.display.flip()

        # Frame rate
        clock.tick(FPS)

    pygame.quit()
    sys.exit()

if __name__ == "__main__":
    game_loop()
