import cv2
import mediapipe as mp
import math
import numpy as np
import time


def extract_keypoints(results):
    pose = (
        np.array(
            [[res.x, res.y, res.z] for res in results.pose_landmarks.landmark[11:17]]
        ).flatten()
        if results.pose_landmarks
        else np.zeros(6 * 3)
    )
    lh = (
        np.array(
            [[res.x, res.y, res.z] for res in results.left_hand_landmarks.landmark]
        ).flatten()
        if results.left_hand_landmarks
        else np.zeros(21 * 3)
    )
    rh = (
        np.array(
            [[res.x, res.y, res.z] for res in results.right_hand_landmarks.landmark]
        ).flatten()
        if results.right_hand_landmarks
        else np.zeros(21 * 3)
    )
    return np.concatenate([pose, lh, rh])


def mediapipe_detection(image, model):
    image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)  # COLOR CONVERSION BGR 2 RGB
    image.flags.writeable = False                   # Image is no longer writeable
    results = model.process(image)                  # Make prediction
    image.flags.writeable = True                    # Image is now writeable
    image = cv2.cvtColor(image, cv2.COLOR_RGB2BGR)  # COLOR COVERSION RGB 2 BGR
    return image, results


def plot_video(joints, file_path, video_name, a_p, skip_frames=1):
    pred_kpts = []

    # Create video template
    FPS = 45 // skip_frames
    video_file = file_path + r"{}.mp4".format(video_name.split(".")[0])
    fourcc = cv2.VideoWriter_fourcc("m", "p", "4", "v")
    video = cv2.VideoWriter(video_file, fourcc, float(FPS), (650, 650), True)

    num_frames = 0

    for j, frame_joints in enumerate(joints):
        
        frame = np.ones((650, 650, 3), np.uint8) * 255

        # Cut off the percent_tok and restore joint size, change according to preprocessing applied
        frame_joints = np.asarray(frame_joints)
        frame_joints = frame_joints[:] * 4

        # Reduce the frame joints down to 2D for visualisation
        frame_joints_2d = np.reshape(frame_joints, (48, 3))[:, :2]
        # Draw the frame given 2D joints
        draw_frame_2D(frame, frame_joints_2d)

        pred_kpts.append(frame_joints_2d)
        if a_p == 0:
            cv2.putText(
                frame,
                "Predicted Sign Pose",
                (180, 600),
                cv2.FONT_HERSHEY_SIMPLEX,
                1,
                (10, 0, 255),
                2,
            )
        elif a_p == 1:
            cv2.putText(
                frame,
                "Actual Sign Pose",
                (180, 600),
                cv2.FONT_HERSHEY_SIMPLEX,
                1,
                (10, 0, 255),
                2,
            )
        else:
            cv2.putText(
                frame,
                "Sign Pose Output",
                (180, 600),
                cv2.FONT_HERSHEY_SIMPLEX,
                1,
                (10, 0, 255),
                2,
            )

        # Write the video frame
        video.write(frame)

        num_frames += 1

    # Release the video

    video.release()


# This is the format of the 3D data, outputted from the Inverse Kinematics model
def draw_frame_2D(frame, joints):
    # Line to be between the stacked
    # draw_line(frame, [1, 650], [1, 1], c=(0,0,0), t=1, width=1)
    # Give an offset to center the skeleton around
    offset = [200, 20]
    # Get the skeleton structure details of each bone, and size
    skeleton = getSkeletalModelStructure()
    skeleton = np.array(skeleton)
    number = skeleton.shape[0]
    # print(skeleton)
    # Increase the size and position of the joints
    joints = joints * 10 * 4 * 2
    joints = joints + np.ones((48, 2)) * offset
    # Loop through each of the bone structures, and plot the bone
    for j in range(number):
        c = get_bone_colour(skeleton, j, joints)
        j1 = [joints[skeleton[j, 0]][0], joints[skeleton[j, 0]][1]]
        j2 = [joints[skeleton[j, 1]][0], joints[skeleton[j, 1]][1]]

        draw_line(frame, j1, j2, c=c, t=1, width=2)


def draw_line(im, joint1, joint2, c, t=1, width=2):
    thresh = -100
    if (
        joint1[0] > thresh
        and joint1[1] > thresh
        and joint2[0] > thresh
        and joint2[1] > thresh
    ):
        center = (int((joint1[0] + joint2[0]) / 2), int((joint1[1] + joint2[1]) / 2))
        length = int(
            math.sqrt(((joint1[0] - joint2[0]) ** 2) + ((joint1[1] - joint2[1]) ** 2))
            / 2
        )
        angle = math.degrees(
            math.atan2((joint1[0] - joint2[0]), (joint1[1] - joint2[1]))
        )
        cv2.ellipse(im, center, (width, length), -angle, 0.0, 360.0, c, -1)


def get_bone_colour(skeleton, j, joints):
    bone = skeleton[j, 1]
    c = (0, 0, 0)
    if bone in [0, 1]:  # Shoulder
        c = (0, 0, 255)
    elif bone == 2 and skeleton[j, 0] == 0:  # left arm
        c = (139, 0, 0)
    elif bone == 4 and skeleton[j, 0] == 2:  # left lower arm
        c = (139, 0, 0)

    elif bone == 3 and skeleton[j, 0] == 1:  # right arm
        c = (0, 153, 0)
    elif bone == 5 and skeleton[j, 0] == 3:  # right lower arm
        c = (0, 204, 0)

    # Hands
    elif bone in [6, 7, 8, 9, 10, 27]:
        c = (0, 98, 255)
    elif bone in [28, 29, 30, 31]:
        c = (110, 120, 130)
    elif bone in [14, 11, 12, 13, 34, 35, 32, 33]:
        c = (51, 255, 51)
    elif bone in [15, 16, 17, 18, 36, 37, 38, 39]:
        c = (255, 0, 0)
    elif bone in [19, 20, 21, 22, 40, 41, 42, 43]:
        c = (204, 153, 255)
    elif bone in [23, 24, 25, 26, 44, 45, 46, 47]:
        c = (51, 255, 255)
    return c


def getSkeletalModelStructure():
    return (
        # shoulder
        (0, 1),
        # left arm
        (0, 2),
        # right arm
        (1, 3),
        # lower left arm
        (2, 4),
        # lower right arm
        (3, 5),
        # left hand thumb
        (6, 7),
        (7, 8),
        (8, 9),
        (9, 10),
        # left hand index finger
        (6, 11),
        (11, 12),
        (12, 13),
        (13, 14),
        # left hand middle finger
        (11, 15),
        (15, 16),
        (16, 17),
        (17, 18),
        # left hand ring finger
        (15, 19),
        (19, 20),
        (20, 21),
        (21, 22),
        # left hand pinky
        (6, 23),
        (19, 23),
        (23, 24),
        (24, 25),
        (25, 26),
        # right hand thumb
        (27, 28),
        (28, 29),
        (29, 30),
        (30, 31),
        # right hand idex finger
        (27, 32),
        (32, 33),
        (33, 34),
        (34, 35),
        # right hand middle finger
        (32, 36),
        (36, 37),
        (37, 38),
        (38, 39),
        # right hand ring finger
        (36, 40),
        (40, 41),
        (41, 42),
        (42, 43),
        # right hand thumb
        (27, 44),
        (40, 44),
        (44, 45),
        (45, 46),
        (46, 47),
    )


def plot(path):
    Points = []
    mp_holistic = mp.solutions.holistic

    holistic = mp_holistic.Holistic(
        min_detection_confidence=0.5, min_tracking_confidence=0.5
    )

    video = cv2.VideoCapture(path)
    print("Extracting Keypoints...")
    start_time = time.time()
    while video.isOpened():
        # Read feed
        ret, frame = video.read()
        if not ret:
            break
        # Make detections
        image, results = mediapipe_detection(frame, holistic)
        # NEW Export keypoints
        keypoints = extract_keypoints(results)
        start_index = 18
        end_index = 143
        # Check if the specified portion of the array is all zeros
        is_zero = all(element == 0 for element in keypoints[start_index:end_index])
        if is_zero:
            continue
        Points.append(keypoints)
    video.release()
    elapsed_time = time.time() - start_time
    print(f"Time Taken to Generate Pose Sign Language is: {elapsed_time}\n")
    print("Plotting Pose Output...")
    plot_video(
        Points,
        file_path=r"D:\FYP APP\STSL - APP\stsl\backend\Data",
        video_name=r"\Pose.mp4",
        a_p=2,
        skip_frames=1,
    )
    print("Done")