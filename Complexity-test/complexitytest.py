import time


def execTime(iter):

    start = time.time()
    print("start time: ",start)

    a = 0
    for i in range(10**iter):
        a = i
        if i % (10**(iter-1)) == 0:
            print("step")
    print("final value: ", a)
    end = time.time()
    print("end time: ", end)

    print(f"The time of execution of 10^{iter} iterations is:  {end-start}")

if __name__ == "__main__":
    while True:
        try:
            i = int(input("How many iterations? Give an exponent of 10: "))
        except ValueError:
            print("This is an unaccepted response, enter a valid value")
            continue
        else:
            break
    execTime(i)