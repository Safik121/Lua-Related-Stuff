using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WaypointReach : MonoBehaviour
{
    [SerializeField] private GameObject[] waypoints;
    private int momentalniVejpointXDDDD = 0;

    [SerializeField] private float rychlostMOREjedeme = 2f;

    private void Update()
    {
        if (Vector2.Distance(waypoints[momentalniVejpointXDDDD].transform.position, transform.position) < .1f)
        {
            momentalniVejpointXDDDD++;
            if(momentalniVejpointXDDDD >= waypoints.Length)
            {
                momentalniVejpointXDDDD = 0;
            }
        }
        transform.position = Vector2.MoveTowards(transform.position, waypoints[momentalniVejpointXDDDD].transform.position, Time.deltaTime * rychlostMOREjedeme);
    }
}
